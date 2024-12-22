// lib/ui/screens/comments_screen.dart

import 'dart:io';

import 'package:citizeneye/data/models/comment_model.dart';
import 'package:citizeneye/data/models/project_model.dart';
import 'package:citizeneye/logic/services/project_service.dart';
import 'package:citizeneye/ui/components/comment_input_component.dart';
import 'package:citizeneye/ui/components/comment_tile_component.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  final ProjectModel project;

  const CommentsScreen({
    super.key,
    required this.project,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Comment> _comments = [];
  ProjectModel? _projectModel;
  final TextEditingController _commentController = TextEditingController();

  void _addComment(String content, int id, {File? media}) async {
    _commentController.clear();
    final result = await commentProject(
      id: id,
      content: content,
      media: media,
    );
    if (result['status']) {
      setState(() {
        _projectModel!.updateOrAddComment(Comment.fromJson(result['comment']));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initComments();
  }

  initComments() {
    setState(() {
      _projectModel = widget.project;
      _comments = widget.project.comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _comments.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: Text('Aucun commentaire disposnible'),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return CommentTile(
                            comment: comment,
                            onLikeToggle: () {},
                            onReply: () {},
                          );
                        },
                      ),
                    ],
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomAppBar(
              color: Colors.white,
              child: CommentInput(
                controller: _commentController,
                onSend: () => _addComment(
                  _commentController.text,
                  _projectModel!.id,
                ),
                onPickImage: () {},
                profileImageUrl: 'https://via.placeholder.com/100x100.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
