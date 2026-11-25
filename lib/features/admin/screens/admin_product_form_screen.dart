import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/core/Widgets/text_form_feild.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/admin/controllers/admin_products_cubit.dart';
import 'package:volt/features/admin/controllers/admin_products_states.dart';
import 'package:volt/features/admin/widgets/admin_product_tile.dart';
import 'package:volt/features/products/models/product_model.dart';

/// Add a product (no [product]) or edit one. Editing covers name, price,
/// description, category, status, company, stock and the offer (discount
/// percent). Images are chosen when adding; the API cannot change the
/// images of an existing product.
class AdminProductFormScreen extends StatefulWidget {
  final Product? product;
  final String? presetCompany;
  const AdminProductFormScreen({super.key, this.product, this.presetCompany});

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final companyController = TextEditingController();
  final stockController = TextEditingController();
  final discountController = TextEditingController();
  String category = AdminProductsCubit.categories.first;
  String status = AdminProductsCubit.statuses.first;
  final List<XFile> pickedImages = [];

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      nameController.text = (p.name ?? '').trim();
      // The regular price: the one before any offer.
      priceController.text = formatPrice(p.originalPrice ?? p.price);
      descriptionController.text = (p.description ?? '').trim();
      companyController.text = (p.company ?? '').trim();
      stockController.text = '${p.countInStock ?? 0}';
      if (p.hasOffer) discountController.text = formatPrice(p.discountPercent);
      if (AdminProductsCubit.categories.contains(p.category)) {
        category = p.category!;
      }
      if (AdminProductsCubit.statuses.contains(p.status)) status = p.status!;
    } else if (widget.presetCompany != null) {
      companyController.text = widget.presetCompany!;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    companyController.dispose();
    stockController.dispose();
    discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final files = await ImagePicker().pickMultiImage(
      imageQuality: 70,
      maxWidth: 1200,
    );
    if (files.isNotEmpty) setState(() => pickedImages.addAll(files));
  }

  Future<List<String>> _encodeImages() async {
    final out = <String>[];
    for (final f in pickedImages) {
      final bytes = await f.readAsBytes();
      final ext = f.path.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      out.add('data:image/$ext;base64,${base64Encode(bytes)}');
    }
    return out;
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    final cubit = AdminProductsCubit.get(context);
    final price = num.parse(priceController.text.trim());
    final stock = int.parse(stockController.text.trim());
    final discount = double.tryParse(discountController.text.trim());
    bool ok;
    if (isEdit) {
      ok = await cubit.updateProduct(
        product: widget.product!,
        name: nameController.text.trim(),
        price: price,
        description: descriptionController.text.trim(),
        category: category,
        status: status,
        company: companyController.text.trim(),
        countInStock: stock,
        discountPercent: discount,
      );
    } else {
      if (pickedImages.isEmpty) {
        showToast('Pick at least one image', ToastStates.ERROR);
        return;
      }
      ok = await cubit.addProduct(
        name: nameController.text.trim(),
        price: price,
        description: descriptionController.text.trim(),
        category: category,
        status: status,
        company: companyController.text.trim(),
        countInStock: stock,
        images: await _encodeImages(),
        discountPercent: discount,
      );
    }
    if (ok && mounted) Navigator.pop(context);
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _number(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = num.tryParse(v.trim());
    if (n == null || n < 0) return 'Enter a valid number';
    return null;
  }

  String? _wholeNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v.trim());
    if (n == null || n < 0) return 'Enter a whole number';
    return null;
  }

  String? _percent(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = double.tryParse(v.trim());
    if (n == null || n < 0 || n >= 100) return '0 to 99';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final companies = AdminProductsCubit.get(
      context,
    ).companies.map((c) => c.name).toList();
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit product' : 'Add product'),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminProductsCubit, AdminProductsStates>(
        builder: (context, state) {
          final saving = state is AdminProductSavingState;
          return SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (!isEdit) ...[
                    _imagesPicker(),
                    const SizedBox(height: 14),
                  ] else if (widget.product!.image != null) ...[
                    Text(
                      'Images cannot be changed on an existing product.',
                      style: TextStyle(
                        color: AppColors.subTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  DefaultFieldForm(
                    controller: nameController,
                    keyboard: TextInputType.text,
                    valid: _required,
                    label: 'Name',
                    prefix: Icons.label_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultFieldForm(
                          controller: priceController,
                          keyboard: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          valid: _number,
                          label: 'Price',
                          prefix: Icons.attach_money_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DefaultFieldForm(
                          controller: discountController,
                          keyboard: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          valid: _percent,
                          label: 'Offer %',
                          hint: 'No offer',
                          prefix: Icons.percent_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  DefaultFieldForm(
                    controller: stockController,
                    keyboard: TextInputType.number,
                    valid: _wholeNumber,
                    label: 'Stock',
                    prefix: Icons.inventory_2_outlined,
                  ),
                  const SizedBox(height: 14),
                  DefaultFieldForm(
                    controller: companyController,
                    keyboard: TextInputType.text,
                    valid: _required,
                    label: 'Company',
                    prefix: Icons.business_outlined,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: [
                      for (final c in companies)
                        ActionChip(
                          label: Text(c, style: const TextStyle(fontSize: 12)),
                          backgroundColor: AppColors.p2Color,
                          labelStyle: TextStyle(color: AppColors.textColor),
                          onPressed: () =>
                              setState(() => companyController.text = c),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _dropdown(
                    'Category',
                    category,
                    AdminProductsCubit.categories,
                    (v) => setState(() => category = v),
                  ),
                  const SizedBox(height: 14),
                  _dropdown(
                    'Status',
                    status,
                    AdminProductsCubit.statuses,
                    (v) => setState(() => status = v),
                  ),
                  const SizedBox(height: 14),
                  DefaultFieldForm(
                    controller: descriptionController,
                    keyboard: TextInputType.multiline,
                    valid: _required,
                    label: 'Description',
                    prefix: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.p3Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: saving ? null : _save,
                      child: saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEdit ? 'Save changes' : 'Add product',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: AppColors.p2Color,
      style: TextStyle(color: AppColors.textColor),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.defaultColor.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withValues(alpha: 0.6),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: [
        for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _imagesPicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Images (first is the main one)',
                style: TextStyle(color: AppColors.textColor),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _pickImages,
                icon: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.p3Color,
                ),
                label: Text('Pick', style: TextStyle(color: AppColors.p3Color)),
              ),
            ],
          ),
          if (pickedImages.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: pickedImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(pickedImages[i].path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => setState(() => pickedImages.removeAt(i)),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
