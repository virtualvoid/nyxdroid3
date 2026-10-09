// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

typedef AttachmentPicker = Future<XFile?> Function();

final attachmentPickerProvider = Provider<AttachmentPicker>(
  (ref) =>
      () => ImagePicker().pickImage(source: ImageSource.gallery),
);

enum SendOutcome { sent, empty, noRecipient, failed }

enum AttachmentProblem { unreadable }
