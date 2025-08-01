import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../../domain/entity/notification.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/create_notification_usecase.dart';
import '../../domain/usecases/update_notification_usecase.dart';
import '../../domain/usecases/upload_notification_image_usecase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: BlocProvider.of<NotificationBloc>(context),
                  child: NotificationModal(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications found.'));
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: notification.image != null
                      ? Image.network(notification.image!,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.notifications),
                  title: Text(notification.title),
                  subtitle: Text(notification.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                              value: BlocProvider.of<NotificationBloc>(context),
                              child:
                                  NotificationModal(notification: notification),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<NotificationBloc>()
                              .add(DeleteNotification(notification.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class NotificationModal extends StatefulWidget {
  final NotificationEntity? notification;
  const NotificationModal({this.notification, super.key});

  @override
  State<NotificationModal> createState() => _NotificationModalState();
}

class _NotificationModalState extends State<NotificationModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _onTapLinkController;
  DateTime? _dateTime;
  bool _isVisible = true;
  File? _imageFile;
  String? _imageUrl;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.notification?.title ?? '');
    _descController =
        TextEditingController(text: widget.notification?.description ?? '');
    _onTapLinkController =
        TextEditingController(text: widget.notification?.onTapLink ?? '');
    _dateTime = widget.notification?.dateTime;
    _isVisible = widget.notification?.isVisible ?? true;
    _imageUrl = widget.notification?.image;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _onTapLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      setState(() => _uploading = true);
      final params = UploadNotificationImageParams(
          _imageFile!,
          _titleController.text.isNotEmpty
              ? _titleController.text
              : 'untitled');
      context.read<NotificationBloc>().add(UploadNotificationImage(params));
    }
  }

  void _deleteImage() {
    setState(() {
      _imageFile = null;
      _imageUrl = null;
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final notification = NotificationEntity(
        id: widget.notification?.id ?? _titleController.text,
        title: _titleController.text,
        description: _descController.text,
        dateTime: _dateTime ?? DateTime.now(),
        image: _imageUrl,
        isVisible: _isVisible,
        onTapLink: _onTapLinkController.text.isNotEmpty
            ? _onTapLinkController.text
            : null,
      );
      if (widget.notification == null) {
        context.read<NotificationBloc>().add(CreateNotification(
            CreateNotificationParams(notification, image: _imageFile)));
      } else {
        context.read<NotificationBloc>().add(UpdateNotification(
            UpdateNotificationParams(notification, image: _imageFile)));
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _sendPushNotification() async {
    const serverKey =
        'AAAAosTE_-A:APA91bFuAGZj3tt6oQHv1oZLXw2KcyLA7zRj_FPED-27BAz9g99DGvaSGm6lq4cYmjAKIXTsK1wpmZzvH0Wny9tMkqY9wI6Bh5e1qWZHcqopdrE3bYufb7QEW9ickPgQd3SbkepW98_f'; // Replace with your FCM server key
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final payload = {
      'to': '/topics/all',
      'notification': {
        'title': _titleController.text,
        'body': _descController.text,
        if (_imageUrl != null) 'image': _imageUrl,
      },
      'data': {
        if (_onTapLinkController.text.isNotEmpty)
          'link': _onTapLinkController.text,
      },
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(payload));
    print('FCM response status: ${response.statusCode}');
    print('FCM response body: ${response.body}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.statusCode == 200
              ? 'Push notification sent!'
              : 'Failed to send push notification'),
        ),
      );
    }
  }

  Future<void> _sendPushNotificationV1() async {
    final serviceAccountPath =
        'assets/arjun-guruji-app-firebase-adminsdk-cas8x-35276622b4.json';
    final projectId = 'arjun-guruji-app';
    // Load service account from assets
    final serviceAccountJson = await rootBundle.loadString(serviceAccountPath);
    final serviceAccount =
        ServiceAccountCredentials.fromJson(json.decode(serviceAccountJson));
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccount, scopes);
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
    final payload = {
      'message': {
        'topic': 'all', // or 'token': '<device_token>'
        'notification': {
          'title': _titleController.text,
          'body': _descController.text,
          if (_imageUrl != null) 'image': _imageUrl,
        },
        'data': {
          if (_onTapLinkController.text.isNotEmpty)
            'link': _onTapLinkController.text,
        },
      }
    };
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    print('FCM v1 response status: ${response.statusCode}');
    print('FCM v1 response body: ${response.body}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.statusCode == 200
              ? 'Push notification sent (v1)!'
              : 'Failed to send push notification (v1)'),
        ),
      );
    }
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationOperationSuccess &&
            state.message.startsWith('http')) {
          setState(() {
            _imageUrl = state.message;
            _uploading = false;
          });
        } else if (state is NotificationError) {
          setState(() => _uploading = false);
        }
      },
      child: AlertDialog(
        title: Text(widget.notification == null
            ? 'Create Notification'
            : 'Edit Notification'),
        content: SizedBox(
          width: 400,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 600),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _descController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: _onTapLinkController,
                      decoration:
                          const InputDecoration(labelText: 'On Tap Link'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(_dateTime == null
                              ? 'Date'
                              : _dateTime!.toLocal().toString().split(' ')[0]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dateTime ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setState(() => _dateTime = picked);
                          },
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: const Text('Visible'),
                      value: _isVisible,
                      onChanged: (val) => setState(() => _isVisible = val),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('Upload Image'),
                      onPressed: _uploading ? null : _pickImage,
                    ),
                    if (_uploading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    if (_imageUrl != null)
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.network(_imageUrl!,
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _deleteImage,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.notification == null ? 'Create' : 'Update'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Send as Push Notification (v1)'),
            onPressed: _sendPushNotificationV1,
          ),
        ],
      ),
    );
  }
}
