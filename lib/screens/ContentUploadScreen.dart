// content_upload_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retali/services/api_service.dart';
import 'package:video_player/video_player.dart';
import '../widgets/loading_overlay.dart';

class ContentUploadScreen extends StatefulWidget {
  const ContentUploadScreen({Key? key}) : super(key: key);

  @override
  State<ContentUploadScreen> createState() => _ContentUploadScreenState();
}

class _ContentUploadScreenState extends State<ContentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<MediaItem> _mediaItems = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    for (var item in _mediaItems) {
      if (item.type == MediaType.video && item.videoController != null) {
        item.videoController!.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, MediaType type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? mediaFile;
      if (type == MediaType.image) {
        mediaFile = await picker.pickImage(
          source: source,
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1080,
        );
      } else {
        mediaFile = await picker.pickVideo(
          source: source,
          maxDuration: const Duration(minutes: 10),
        );
      }
      if (mediaFile != null) {
        if (type == MediaType.video) {
          final VideoPlayerController controller = VideoPlayerController.file(
            File(mediaFile.path),
          );
          await controller.initialize();
          setState(() {
            _mediaItems.add(
              MediaItem(
                file: File(mediaFile!.path),
                type: MediaType.video,
                videoController: controller,
              ),
            );
          });
        } else {
          setState(() {
            _mediaItems.add(
              MediaItem(
                file: File(mediaFile!.path),
                type: MediaType.image,
              ),
            );
          });
        }
      }
    } catch (e) {
      showErrorSnackbar('Error picking media: $e');
    }
  }

  void showErrorSnackbar(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        elevation: 0,
      ),
    );
  }

  void _removeMedia(int index) {
    final item = _mediaItems[index];
    if (item.type == MediaType.video && item.videoController != null) {
      item.videoController!.dispose();
    }
    setState(() {
      _mediaItems.removeAt(index);
    });
  }

  Future<void> _uploadContent() async {
    if (_mediaItems.isEmpty) {
      showErrorSnackbar('Please add at least one photo or video');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      showErrorSnackbar('Please fill in all required fields');
      return;
    }
    setState(() => _isUploading = true);
    try {
      for (var mediaItem in _mediaItems) {
        await ApiService.uploadContent(
          _titleController.text,
          _descriptionController.text,
          mediaItem.type == MediaType.image ? 'photo' : 'video',
          mediaItem.file,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Upload successful'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar('Upload failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
            appBar: AppBar(
        title: Text(
          'UploadContent',
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: theme.appBarTheme.elevation,
        backgroundColor: theme.primaryColor,
      ),
   
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LoadingOverlay(
        isLoading: _isUploading,
        child: CustomScrollView(
          slivers: [
           
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMediaUploadArea(theme),
                      if (_mediaItems.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildMediaGrid(theme),
                      ],
                      const SizedBox(height: 24),
                      _buildInputForm(theme),
                      const SizedBox(height: 32),
                      _buildUploadButton(theme),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar.medium(
      elevation: theme.appBarTheme.elevation,
      stretch: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.iconTheme?.color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Create Post',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaUploadArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_photo_alternate_rounded,
              size: 32,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add Your Content',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Share your moments with the community',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMediaButton(
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                onTap: () => _pickMedia(ImageSource.camera, MediaType.image),
                color: theme.primaryColor,
                theme: theme,
              ),
              const SizedBox(width: 16),
              _buildMediaButton(
                icon: Icons.videocam_rounded,
                label: 'Video',
                onTap: () => _pickMedia(ImageSource.camera, MediaType.video),
                color: theme.primaryColor,
                theme: theme,
              ),
              const SizedBox(width: 16),
              _buildMediaButton(
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                onTap: () => _showGalleryOptions(theme),
                color: theme.primaryColor,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _mediaItems.length,
      itemBuilder: (context, index) => _buildMediaPreview(index, theme),
    );
  }

  Widget _buildMediaPreview(int index, ThemeData theme) {
    final item = _mediaItems[index];
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
                ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                : BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
                ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                : BorderRadius.circular(16),
            child: item.type == MediaType.image
                ? Image.file(
                    item.file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: VideoPlayer(item.videoController!),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _removeMedia(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputForm(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _titleController,
            label: 'Title',
            hint: 'Enter title',
            icon: Icons.title,
            theme: theme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Enter description',
            icon: Icons.description,
            maxLines: 3,
            theme: theme,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: theme.inputDecorationTheme.border.runtimeType is OutlineInputBorder
                ? (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius
                : BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: theme.primaryColor),
              fillColor: theme.inputDecorationTheme.fillColor,
              border: theme.inputDecorationTheme.border,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isUploading ? null : _uploadContent,
          style: theme.elevatedButtonTheme.style,
          child: _isUploading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_rounded,
                      color: theme.cardTheme.color,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Share Post',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showGalleryOptions(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose Media Type',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGalleryOption(
                  icon: Icons.photo_rounded,
                  label: 'Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia(ImageSource.gallery, MediaType.image);
                  },
                  color: theme.primaryColor,
                  theme: theme,
                ),
                const SizedBox(width: 32),
                _buildGalleryOption(
                  icon: Icons.videocam_rounded,
                  label: 'Video',
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia(ImageSource.gallery, MediaType.video);
                  },
                  color: theme.primaryColor,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum MediaType { image, video }

class MediaItem {
  final File file;
  final MediaType type;
  final VideoPlayerController? videoController;
  MediaItem({
    required this.file,
    required this.type,
    this.videoController,
  });
}