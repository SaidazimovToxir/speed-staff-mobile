import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_event.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_state.dart';

class SeekerDocumentsScreen extends StatelessWidget {
  const SeekerDocumentsScreen({super.key});

  static const Map<String, String> _docTypes = {'diploma': 'Diplom', 'certificate': 'Sertifikat', 'id_card': 'Shaxsga doir hujjat', 'other': 'Boshqa'};

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerProfileBloc, SeekerProfileState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green.shade600, behavior: SnackBarBehavior.floating));
          context.read<SeekerProfileBloc>().add(const ClearSeekerProfileMessages());
        }
        if (state.status == SeekerProfileStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.cFF0000, behavior: SnackBarBehavior.floating));
          context.read<SeekerProfileBloc>().add(const ClearSeekerProfileMessages());
        }
      },
      builder: (context, state) {
        final documents = state.profile?.documents ?? [];
        final isLoading = state.status == SeekerProfileStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.cF6F6F6,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            title: const CustomText(text: 'Hujjatlar', fontSize: 17, fontWeight: FontWeight.w800),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_rounded, color: AppColors.cF9A405, size: 28),
                onPressed: isLoading ? null : () => _showUploadSheet(context),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.cF9A405))
              : documents.isEmpty
              ? _buildEmpty(context)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: documents.length,
                  separatorBuilder: (_, _) => 12.g,
                  itemBuilder: (ctx, i) => _buildDocItem(ctx, documents[i]),
                ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 72, color: Colors.grey.shade300),
          16.g,
          const CustomText(text: 'Hujjatlar mavjud emas', color: Colors.grey),
          8.g,
          PrimaryButton(text: '+ Hujjat yuklash', onPressed: () => _showUploadSheet(context), width: 200, height: 48),
        ],
      ),
    );
  }

  Widget _buildDocItem(BuildContext context, SeekerDocument doc) {
    final isPdf = doc.fileUrl?.toLowerCase().endsWith('.pdf') ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: isPdf ? Colors.red.shade50 : Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: Icon(isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded, color: isPdf ? Colors.red : Colors.blue, size: 28),
          ),
          14.g,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: doc.title, fontSize: 14, fontWeight: FontWeight.w700),
                4.g,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: CustomText(text: _docTypes[doc.docType] ?? doc.docType, fontSize: 11, color: AppColors.cF9A405, fontWeight: FontWeight.w700),
                ),
                if (doc.isVerified) ...[4.g, const CustomText(text: '✓ Tasdiqlangan', fontSize: 11, color: Colors.green)],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () => _confirmDelete(context, doc.id),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("O'chirilsinmi?"),
        content: const Text("Bu hujjat profilddan o'chiriladi."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Bekor')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SeekerProfileBloc>().add(DeleteSeekerDocument(docId));
            },
            child: const Text("O'chirish"),
          ),
        ],
      ),
    );
  }

  void _showUploadSheet(BuildContext context) {
    String selectedDocType = 'diploma';
    final titleCtrl = TextEditingController();
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.viewInsetsOf(context).bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                20.g,
                const CustomText(text: 'Hujjat yuklash', fontSize: 18, fontWeight: FontWeight.w800),
                20.g,
                const CustomText(text: 'Hujjat turi', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.blueGrey),
                12.g,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _docTypes.entries
                      .map(
                        (e) => ChoiceChip(
                          label: Text(e.value),
                          selected: selectedDocType == e.key,
                          onSelected: (_) => setSheetState(() => selectedDocType = e.key),
                          selectedColor: AppColors.cF9A405.withValues(alpha: 0.15),
                          labelStyle: TextStyle(color: selectedDocType == e.key ? AppColors.cF9A405 : Colors.black, fontWeight: FontWeight.w600),
                          side: BorderSide(color: selectedDocType == e.key ? AppColors.cF9A405 : Colors.grey.shade300),
                        ),
                      )
                      .toList(),
                ),
                16.g,
                const CustomText(text: 'Sarlavha', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.blueGrey),
                8.g,
                CustomTextField(controller: titleCtrl, hintText: "Masalan: Oshpazlik diplomi"),
                20.g,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.image_rounded),
                        label: const Text('Rasm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final picked = await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null && context.mounted) {
                            final title = titleCtrl.text.trim().isEmpty ? picked.name : titleCtrl.text.trim();
                            Navigator.pop(ctx);
                            context.read<SeekerProfileBloc>().add(UploadSeekerDocument(filePath: picked.path, title: title, docType: selectedDocType));
                          }
                        },
                      ),
                    ),
                    12.g,
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file_rounded),
                        label: const Text('PDF Fayl'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final picked = await picker.pickMedia();
                          if (picked != null && context.mounted) {
                            final title = titleCtrl.text.trim().isEmpty ? picked.name : titleCtrl.text.trim();
                            Navigator.pop(ctx);
                            context.read<SeekerProfileBloc>().add(UploadSeekerDocument(filePath: picked.path, title: title, docType: selectedDocType));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                16.g,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
