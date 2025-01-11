// widgets/signature_tile.dart
import 'package:citizeneye/data/models/signature_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignatureTile extends StatelessWidget {
  final SignatureModel signature;
  final VoidCallback onReply;

  const SignatureTile({
    super.key,
    required this.signature,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                CircleAvatar(
                  radius: 12.0,
                  backgroundImage: signature.user.avatar != null
                      ? NetworkImage(signature.user.avatar!)
                      : const AssetImage(
                              'assets/images/profile_placeholder.png')
                          as ImageProvider,
                  backgroundColor: Colors.blueGrey[200],
                ),
                const SizedBox(width: 3),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    '${signature.user.name} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(
                  FontAwesomeIcons.gift,
                  color: Colors.blueGrey,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
