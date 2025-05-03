import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isExpanded = false;
  final int _maxLength = 200;
  final currentYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎉 Event title
              Center(
                child: Text(
                  widget.event.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // 📅 Event date
              Row(children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.event.eventDate != null
                      ? DateFormat('d MMMM yyyy')
                      .format(widget.event.eventDate!)
                      : 'TBD',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),

              // 📍 Event location
              Row(
                children: [
                  if (widget.event.theaterName != null) ...[
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.event.theaterName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16.0),

              // Kids OK badge
              if (widget.event.kidsOk)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.suitableForKids,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),


                if (widget.event.kidsOk)
                  const SizedBox(height: 8.0),

                // Summary
                if (widget.event.summary != null && widget.event.summary!.trim().isNotEmpty)
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: '${AppLocalizations.of(context)!.eventDatailsSummary}: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        TextSpan(text: widget.event.summary),
                      ],
                    ),
                  ),

              if (widget.event.eventContent != null)
                const SizedBox(height: 16.0),

              // 🎫 Tickets link
              if (widget.event.eventContent != null)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.local_activity_rounded),
                        label: Text(AppLocalizations.of(context)!.tickets),
                        onPressed: () {
                          launchUrl(Uri.parse('https://tickets.texnopolis.net/'));
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16.0),

              // 📜 Description
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.event.eventContent ??
                          'No description available.'
                    ),
                    // TextSpan(
                    //   text: _isExpanded
                    //       ? widget.event.eventContent ??
                    //       'No description available.'
                    //       : _shortenedDescription,
                    // ),
                    // if (widget.event.eventContent != null &&
                    //     widget.event.eventContent!.length > _maxLength &&
                    //     !_isExpanded)
                    //   TextSpan(
                    //     text: ' ${AppLocalizations.of(context)!.readMore}',
                    //     style: TextStyle(
                    //       color: Theme.of(context).colorScheme.primary,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         setState(() {
                    //           _isExpanded = true;
                    //         });
                    //       },
                    //   ),
                    // if (widget.event.eventContent != null &&
                    //     widget.event.eventContent!.length > _maxLength &&
                    //     _isExpanded)
                    //   TextSpan(
                    //     text: ' ${AppLocalizations.of(context)!.readLess}',
                    //     style: TextStyle(
                    //       color: Theme.of(context).colorScheme.primary,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         setState(() {
                    //           _isExpanded = false;
                    //         });
                    //       },
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetail(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 5,
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String get _shortenedDescription {
    if (widget.event.eventContent == null ||
        widget.event.eventContent!.length <= _maxLength) {
      return widget.event.eventContent ?? 'No description available.';
    } else {
      return '${widget.event.eventContent!.substring(0, _maxLength)}...';
    }
  }
}
