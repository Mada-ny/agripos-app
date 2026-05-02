import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../data/farmer.dart';
import '../providers/edit_farmer_provider.dart';
import '../providers/farmer_account_provider.dart';
import '../providers/farmers_provider.dart';

class EditFarmerScreen extends ConsumerStatefulWidget {
  final Farmer farmer;

  const EditFarmerScreen({super.key, required this.farmer});

  @override
  ConsumerState<EditFarmerScreen> createState() => _EditFarmerScreenState();
}

class _EditFarmerScreenState extends ConsumerState<EditFarmerScreen> {
  late final TextEditingController _idController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _creditController;

  final _firstnameFocus = FocusNode();
  final _lastnameFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();
  final _creditFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.farmer.identifier);
    _firstnameController = TextEditingController(text: widget.farmer.firstname);
    _lastnameController = TextEditingController(text: widget.farmer.lastname);
    // Strip +225 prefix for the local number field
    final localNumber = widget.farmer.phone.startsWith('+225')
        ? widget.farmer.phone.substring(4)
        : widget.farmer.phone;
    _phoneNumberController = TextEditingController(text: localNumber);
    _creditController = TextEditingController(
      text: widget.farmer.creditLimit.toInt().toString(),
    );

    for (final fn in [
      _firstnameFocus,
      _lastnameFocus,
      _phoneNumberFocus,
      _creditFocus,
    ]) {
      fn.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneNumberController.dispose();
    _creditController.dispose();
    _firstnameFocus.dispose();
    _lastnameFocus.dispose();
    _phoneNumberFocus.dispose();
    _creditFocus.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final credit =
        double.tryParse(_creditController.text.replaceAll(' ', '')) ?? 0;
    final phoneDigits = _phoneNumberController.text.replaceAll(' ', '');
    return _firstnameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        phoneDigits.length == 10 &&
        credit > 0;
  }

  void _submit() {
    final creditText = _creditController.text.replaceAll(' ', '');
    ref
        .read(editFarmerNotifierProvider.notifier)
        .submit(
          farmerId: widget.farmer.id,
          identifier: _idController.text.trim(),
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
          phone: '+225${_phoneNumberController.text.trim()}',
          creditLimit: double.parse(creditText),
        );
  }

  String? _fieldError(String field, AsyncValue state) {
    if (!state.hasError) return null;
    final err = state.error;
    if (err is AppException) {
      final list = err.errors?[field];
      if (list is List && list.isNotEmpty) return list.first.toString();
    }
    return null;
  }

  String? _generalError(AsyncValue state) {
    if (!state.hasError) return null;
    final err = state.error;
    if (err is AppException) {
      if (err.errors == null || err.errors!.isEmpty) return err.message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(editFarmerNotifierProvider);
    final isLoading = submitState.isLoading;

    ref.listen(editFarmerNotifierProvider, (previous, next) {
      if (previous is AsyncLoading &&
          next is AsyncData<Farmer?> &&
          next.value != null) {
        ref.invalidate(farmerDetailProvider(widget.farmer.id));
        ref.read(farmerListVersionProvider.notifier).refresh();
        if (context.mounted) context.pop();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFfaf6ef),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfaf6ef),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF231a10),
            size: 22,
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit farmer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF231a10),
              ),
            ),
            Text(
              widget.farmer.fullName,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6b5d48)),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFe3d8c2)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('IDENTITY'),
                  const SizedBox(height: 12),
                  _LabeledField(
                    label: 'Farmer ID',
                    controller: _idController,
                    enabled: false,
                    placeholder: widget.farmer.identifier,
                    hint: 'Unique identifier — cannot be changed',
                    context: context,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _LabeledField(
                          label: 'First name',
                          controller: _firstnameController,
                          focusNode: _firstnameFocus,
                          nextFocus: _lastnameFocus,
                          enabled: !isLoading,
                          placeholder: 'First name',
                          errorText: _fieldError('firstname', submitState),
                          textCapitalization: TextCapitalization.words,
                          context: context,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LabeledField(
                          label: 'Last name',
                          controller: _lastnameController,
                          focusNode: _lastnameFocus,
                          nextFocus: _phoneNumberFocus,
                          enabled: !isLoading,
                          placeholder: 'Last name',
                          errorText: _fieldError('lastname', submitState),
                          textCapitalization: TextCapitalization.words,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionLabel('CONTACT'),
                  const SizedBox(height: 12),
                  _PhoneField(
                    controller: _phoneNumberController,
                    focusNode: _phoneNumberFocus,
                    nextFocus: _creditFocus,
                    enabled: !isLoading,
                    errorText: _fieldError('phone', submitState),
                    context: context,
                  ),
                  const SizedBox(height: 24),
                  _sectionLabel('CREDIT SETTINGS'),
                  const SizedBox(height: 12),
                  _LabeledField(
                    label: 'Credit limit',
                    controller: _creditController,
                    focusNode: _creditFocus,
                    enabled: !isLoading,
                    placeholder: '400 000',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffix: const Text(
                      'FCFA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6b5d48),
                      ),
                    ),
                    hint: 'Maximum amount this farmer can owe',
                    errorText: _fieldError('credit_limit', submitState),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (_canSubmit) _submit();
                    },
                    context: context,
                  ),
                  if (_generalError(submitState) != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _generalError(submitState)!,
                      style: const TextStyle(
                        color: Color(0xFFb3321b),
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _ActionBar(
            isLoading: isLoading,
            canSubmit: _canSubmit && !isLoading,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFFa89a82),
        letterSpacing: 1,
      ),
    );
  }
}

// ── Labeled field ─────────────────────────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool enabled;
  final String placeholder;
  final String? hint;
  final String? errorText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;
  final BuildContext context;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.placeholder,
    required this.context,
    this.focusNode,
    this.nextFocus,
    this.hint,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.suffix,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext _) {
    final focused = focusNode?.hasFocus ?? false;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6b5d48),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : const Color(0xFFf3ede2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError
                  ? const Color(0xFFb3321b)
                  : focused
                  ? const Color(0xFF2d5d3a)
                  : const Color(0xFFe3d8c2),
              width: focused || hasError ? 1.5 : 1,
            ),
            boxShadow: focused && !hasError
                ? [
                    const BoxShadow(
                      color: Color(0xFFdde8d8),
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  inputFormatters: inputFormatters,
                  textInputAction:
                      textInputAction ??
                      (nextFocus != null
                          ? TextInputAction.next
                          : TextInputAction.done),
                  onSubmitted:
                      onSubmitted ??
                      (nextFocus != null
                          ? (_) =>
                                FocusScope.of(context).requestFocus(nextFocus)
                          : null),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: enabled
                        ? const Color(0xFF231a10)
                        : const Color(0xFF6b5d48),
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFa89a82),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              if (suffix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: suffix!,
                ),
            ],
          ),
        ),
        if (hint != null && errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            hint!,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6b5d48)),
          ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFb3321b),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Phone field ───────────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final bool enabled;
  final String? errorText;
  final BuildContext context;

  const _PhoneField({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.context,
    this.nextFocus,
    this.errorText,
  });

  @override
  Widget build(BuildContext _) {
    final focused = focusNode.hasFocus;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6b5d48),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError
                  ? const Color(0xFFb3321b)
                  : focused
                  ? const Color(0xFF2d5d3a)
                  : const Color(0xFFe3d8c2),
              width: focused || hasError ? 1.5 : 1,
            ),
            boxShadow: focused && !hasError
                ? [
                    const BoxShadow(
                      color: Color(0xFFdde8d8),
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: const Text(
                  '+225',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6b5d48),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: const Color(0xFFe3d8c2)),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  textInputAction: nextFocus != null
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onSubmitted: nextFocus != null
                      ? (_) => FocusScope.of(context).requestFocus(nextFocus)
                      : null,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF231a10),
                  ),
                  decoration: const InputDecoration(
                    hintText: '07 00 00 00 00',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFa89a82),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFb3321b),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Action bar ────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final bool isLoading;
  final bool canSubmit;
  final VoidCallback onSubmit;

  const _ActionBar({
    required this.isLoading,
    required this.canSubmit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFe3d8c2))),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: canSubmit ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_outlined, size: 20),
          label: const Text(
            'Save changes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
