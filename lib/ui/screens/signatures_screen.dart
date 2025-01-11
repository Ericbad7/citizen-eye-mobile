import 'package:citizeneye/data/models/signature_model.dart';
import 'package:citizeneye/ui/components/signature_tile_component.dart';
import 'package:citizeneye/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class SignaturesScreen extends StatefulWidget {
  final List<SignatureModel> signatures;

  const SignaturesScreen({
    super.key,
    required this.signatures,
  });

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        backgroundColor: const Color.fromARGB(255, 21, 101, 192),
        title: '${widget.signatures.length} signature(s) obtenue(s)',
      ),
      body: widget.signatures.isEmpty
          ? const Center(
              child: Text('Aucune signature disposnible'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.signatures.length,
                    itemBuilder: (context, index) {
                      final signature =
                          widget.signatures.reversed.toList()[index];
                      return SignatureTile(
                        signature: signature,
                        onReply: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
