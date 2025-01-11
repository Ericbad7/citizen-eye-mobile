import 'package:citizeneye/data/datasources/string_api.dart';
import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/petition_model.dart';
import 'package:citizeneye/data/models/signature_model.dart';
import 'package:citizeneye/logic/services/petition_service.dart';
import 'package:citizeneye/ui/screens/auth_screen.dart';
import 'package:citizeneye/ui/screens/post_petition.dart';
import 'package:citizeneye/ui/screens/project_detail_screen.dart';
import 'package:citizeneye/ui/screens/signatures_screen.dart';
import 'package:citizeneye/utils/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PetitionCard extends StatefulWidget {
  final PetitionModel petition;

  const PetitionCard({
    super.key,
    required this.petition,
  });

  @override
  State<PetitionCard> createState() => _PetitionCardState();
}

class _PetitionCardState extends State<PetitionCard> {
  bool _isExpanded = false;
  bool isProcessing = false;
  String _id = '0';
  PetitionModel? _petitionModel;

  @override
  void initState() {
    super.initState();
    initId();
    initPetition();
  }

  initPetition() {
    _petitionModel = widget.petition;
  }

  initId() async {
    final id = await UserLocalStorage.getId();
    if (id != null) {
      setState(() {
        _id = id;
      });
    }
  }

  void _openBottomSheet(BuildContext context, List<SignatureModel> signatures) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: SignaturesScreen(signatures: signatures),
        );
      },
    );
  }

  void _sign() async {
    if (_id == null) {
      Get.snackbar(
        'Info',
        'Connectez-vous pour réagir à ce post',
      );
      Get.to(() => const AuthScreen());
      return;
    }
    final result = await signPetition(id: _petitionModel!.id);

    if (result['status']) {
      setState(() {
        _petitionModel!
            .updateOrAddSignature(SignatureModel.fromJson(result['signature']));
      });
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible de signer cette pétition',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showConfirmationDialog() {
    Get.defaultDialog(
      title: 'Confirmer la suppression',
      middleText:
          'Êtes-vous sûr de vouloir supprimer cette pétition ? Cette action est irréversible.',
      textCancel: ' Annuler ',
      textConfirm: 'Supprimer',
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () {
        Get.back();
        _delete();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void _delete() async {
    final result = await deletePetition(id: widget.petition.id);

    if (result['status']) {
      Get.snackbar(
        '',
        result['message'],
      );
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible de signer cette pétition',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildImage(height: 200),
          if (widget.petition.project != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    ProjectDetailScreen(
                      project: widget.petition.project!,
                    ),
                  );
                },
                child: Text(
                  widget.petition.project!.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Text(
              widget.petition.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Text(
              widget.petition.description,
              maxLines: _isExpanded ? null : 3,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Lire moins' : 'Lire plus',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.share),
                  onPressed: () {},
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.signature),
                      onPressed: widget.petition.isOwner(_id)
                          ? () {
                              _openBottomSheet(
                                context,
                                widget.petition.signatures,
                              );
                            }
                          : _sign,
                      color: widget.petition.hadSigned(_id)
                          ? Colors.blue
                          : Colors.blueGrey,
                    ),
                    Text(
                      widget.petition.getSignatureCount().toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage({double height = 150}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Image.network(
        '$imagePath/${widget.petition.imageUrl!}',
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  '$imagePath/${widget.petition.imageUrl!}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              widget.petition.owner.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Lancée ${formatDate(widget.petition.createdAt)}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        if (widget.petition.isOwner(_id))
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.blueGrey,
            ),
            onSelected: (String value) {
              switch (value) {
                case '2':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPetitionScreen(
                        id: widget.petition.project!.id,
                        petition: widget.petition,
                      ),
                    ),
                  );

                  break;
                case '1':
                  _showConfirmationDialog();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                height: 32.0,
                value: '2',
                child: Text('Modifier'),
              ),
              const PopupMenuItem<String>(
                height: 32.0,
                value: '1',
                child: Text('Supprimer'),
              ),
            ],
          )
      ],
    );
  }
}
