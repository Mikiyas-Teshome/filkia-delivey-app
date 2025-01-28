import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';

class AddressInputWidget extends StatefulWidget {
  final String apiKey;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;
  final Function(double latitude, double longitude) onCoordinatesChanged;

  const AddressInputWidget({
    super.key,
    required this.apiKey,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
    required this.onCoordinatesChanged,
  });

  @override
  _AddressInputWidgetState createState() => _AddressInputWidgetState();
}

class _AddressInputWidgetState extends State<AddressInputWidget> {
  late FlutterGooglePlacesSdk _places;

  @override
  void initState() {
    super.initState();
    _places = FlutterGooglePlacesSdk(widget.apiKey);
  }

  Future<List<String>> _getAddressSuggestions(String query) async {
    if (query.isEmpty) return [];
    try {
      final predictions = await _places.findAutocompletePredictions(
        query,
        countries: ['US'],
      );
      return predictions.predictions.map((p) => p.fullText ?? '').toList();
    } catch (e) {
      print('Error fetching address suggestions: $e');
      return [];
    }
  }

  Future<void> _fetchPlaceDetails(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        // Notify parent widget of the coordinates
        widget.onCoordinatesChanged(latitude, longitude);

        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

          setState(() {
            widget.cityController.text = place.locality ?? '';
            widget.stateController.text = place.administrativeArea ?? '';
            widget.zipCodeController.text = place.postalCode ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
  }

  OutlineInputBorder _getInputBorder(BuildContext context,
      {Color? color, double width = 1.0}) {
    final theme = Theme.of(context);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color ?? theme.dividerColor,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Field with Autocomplete
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _getAddressSuggestions(textEditingValue.text);
          },
          onSelected: (String selection) {
            widget.addressController.text = selection;
            _fetchPlaceDetails(selection);
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              validator: (value) =>
                  value!.isEmpty ? 'Address is required' : null,
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: theme.iconTheme.color?.withValues( alpha: 0.6),
                ),
                border: _getInputBorder(context),
                enabledBorder: _getInputBorder(context),
                focusedBorder:
                    _getInputBorder(context, color: Colors.amber, width: 1.5),
              ),
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // City Field
        TextFormField(
          controller: widget.cityController,
          validator: (value) => value!.isEmpty ? 'City is required' : null,
          decoration: InputDecoration(
            labelText: 'City',
            prefixIcon: Icon(
              Icons.location_city_outlined,
              color: theme.iconTheme.color?.withValues( alpha: 0.6),
            ),
            border: _getInputBorder(context),
            enabledBorder: _getInputBorder(context),
            focusedBorder:
                _getInputBorder(context, color: Colors.amber, width: 1.5),
          ),
        ),
        const SizedBox(height: 16),

        // State Field
        TextFormField(
          controller: widget.stateController,
          validator: (value) => value!.isEmpty ? 'State is required' : null,
          decoration: InputDecoration(
            labelText: 'State',
            prefixIcon: Icon(
              Icons.map_outlined,
              color: theme.iconTheme.color?.withValues( alpha: 0.6),
            ),
            border: _getInputBorder(context),
            enabledBorder: _getInputBorder(context),
            focusedBorder:
                _getInputBorder(context, color: Colors.amber, width: 1.5),
          ),
        ),
        const SizedBox(height: 16),

        // ZIP Code Field
        TextFormField(
          controller: widget.zipCodeController,
          validator: (value) => value!.isEmpty ? 'ZIP Code is required' : null,
          decoration: InputDecoration(
            labelText: 'ZIP Code',
            prefixIcon: Icon(
              Icons.local_post_office_outlined,
              color: theme.iconTheme.color?.withValues( alpha: 0.6),
            ),
            border: _getInputBorder(context),
            enabledBorder: _getInputBorder(context),
            focusedBorder:
                _getInputBorder(context, color: Colors.amber, width: 1.5),
          ),
        ),
      ],
    );
  }
}
