import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/create_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/update_event_usecase.dart';

class AdminEventsPage extends StatelessWidget {
  const AdminEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: BlocProvider.of<EventBloc>(context),
                  child: EventModal(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return const Center(child: Text('No events found.'));
            }
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.venue),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                              value: BlocProvider.of<EventBloc>(context),
                              child: EventModal(event: event),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<EventBloc>().add(DeleteEvent(event.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is EventError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class EventModal extends StatefulWidget {
  final Event? event;
  const EventModal({this.event, super.key});

  @override
  State<EventModal> createState() => _EventModalState();
}

class _EventModalState extends State<EventModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _venueController;
  late TextEditingController _cityController;
  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'Upcoming';
  List<String> _galleryLinks = [];
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descController =
        TextEditingController(text: widget.event?.description ?? '');
    _venueController = TextEditingController(text: widget.event?.venue ?? '');
    _cityController = TextEditingController(text: widget.event?.city ?? '');
    _startDate = widget.event?.startDate;
    _endDate = widget.event?.endDate;
    _status = widget.event?.status ?? 'Upcoming';
    _galleryLinks = List<String>.from(widget.event?.galleryLinks ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() => _uploading = true);
      final eventName =
          _titleController.text.isNotEmpty ? _titleController.text : 'untitled';
      for (final image in picked) {
        // Dispatch bloc event to upload image
        context
            .read<EventBloc>()
            .add(UploadEventImage(File(image.path), eventName));
      }
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final event = Event(
        id: widget.event?.id ?? UniqueKey().toString(),
        title: _titleController.text,
        description: _descController.text,
        startDate: _startDate ?? DateTime.now(),
        endDate: _endDate ?? DateTime.now(),
        venue: _venueController.text,
        galleryLinks: _galleryLinks,
        interestedCount: widget.event?.interestedCount ?? 0,
        eventType: 'Simple',
        isFeatured: true,
        city: _cityController.text,
        status: _status,
      );
      if (widget.event == null) {
        context
            .read<EventBloc>()
            .add(CreateEvent(CreateEventParams(event, image: null)));
      } else {
        context
            .read<EventBloc>()
            .add(UpdateEvent(UpdateEventParams(event, image: null)));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventOperationSuccess) {
          if (state.message.startsWith('http')) {
            setState(() {
              _galleryLinks.add(state.message);
              _uploading = false;
            });
          }
        } else if (state is EventError) {
          setState(() => _uploading = false);
        }
      },
      child: AlertDialog(
        title: Text(widget.event == null ? 'Create Event' : 'Edit Event'),
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
                    ),
                    TextFormField(
                      controller: _venueController,
                      decoration: const InputDecoration(labelText: 'Venue'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(
                            value: 'Upcoming', child: Text('Upcoming')),
                        DropdownMenuItem(
                            value: 'Completed', child: Text('Completed')),
                        DropdownMenuItem(
                            value: 'Cancelled', child: Text('Cancelled')),
                      ],
                      onChanged: (val) =>
                          setState(() => _status = val ?? 'Upcoming'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(_startDate == null
                              ? 'Start Date'
                              : _startDate!.toLocal().toString().split(' ')[0]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setState(() => _startDate = picked);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(_endDate == null
                              ? 'End Date'
                              : _endDate!.toLocal().toString().split(' ')[0]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setState(() => _endDate = picked);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('Upload Images'),
                      onPressed: _uploading ? null : _pickAndUploadImages,
                    ),
                    if (_uploading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    if (_galleryLinks.isNotEmpty)
                      SizedBox(
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _galleryLinks.length,
                          separatorBuilder: (context, i) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, i) => Image.network(
                              _galleryLinks[i],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover),
                        ),
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
            child: Text(widget.event == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }
}
