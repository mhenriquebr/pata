import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pata/core/widgets/app_snackbar.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';
import 'package:pata/features/pets/domain/entities/vaccination_status.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:provider/provider.dart';

/// Tela de cadastro de um novo pet (Requisito 7 do Trabalho 1).
///
/// É um [StatefulWidget] porque precisa manter o estado local dos
/// campos do formulário (controllers, espécie/sexo/vacinação
/// selecionados, data de nascimento e flag de envio em andamento). Toda
/// a validação de formato acontece aqui (camada de UI); a validação de
/// regra de negócio (ex.: peso > 0) acontece no domínio, dentro da
/// entidade [Pet].
class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  PetSpecies _species = PetSpecies.dog;
  PetSex _sex = PetSex.male;
  VaccinationStatus _vaccinationStatus = VaccinationStatus.upToDate;
  DateTime? _birthDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
      helpText: 'Data de nascimento',
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (_birthDate == null) {
      AppSnackbar.showError(
        context,
        'Selecione a data de nascimento do pet.',
      );
      return;
    }

    if (!isFormValid) {
      return;
    }

    setState(() => _isSubmitting = true);

    final PetProvider provider = context.read<PetProvider>();
    final double weight = double.parse(
      _weightController.text.trim().replaceAll(',', '.'),
    );

    final bool success = await provider.addPet(
      name: _nameController.text,
      species: _species,
      sex: _sex,
      breed: _breedController.text,
      birthDate: _birthDate!,
      weightKg: weight,
      vaccinationStatus: _vaccinationStatus,
      notes: _notesController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (success) {
      AppSnackbar.showSuccess(context, 'Pet cadastrado com sucesso!');
      context.pop();
    } else {
      AppSnackbar.showError(
        context,
        provider.errorMessage ?? 'Não foi possível cadastrar o pet.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Novo pet')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nome *',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o nome do pet.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PetSpecies>(
              initialValue: _species,
              decoration: const InputDecoration(
                labelText: 'Espécie *',
                prefixIcon: Icon(Icons.pets_outlined),
              ),
              items: PetSpecies.values
                  .map(
                    (PetSpecies species) => DropdownMenuItem<PetSpecies>(
                      value: species,
                      child: Text(species.label),
                    ),
                  )
                  .toList(),
              onChanged: (PetSpecies? value) {
                if (value != null) {
                  setState(() => _species = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Sexo *',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 8),
            SegmentedButton<PetSex>(
              segments: PetSex.values
                  .map(
                    (PetSex sex) => ButtonSegment<PetSex>(
                      value: sex,
                      label: Text(sex.label),
                      icon:
                          Icon(sex == PetSex.male ? Icons.male : Icons.female),
                    ),
                  )
                  .toList(),
              selected: <PetSex>{_sex},
              onSelectionChanged: (Set<PetSex> selection) {
                setState(() => _sex = selection.first);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Raça *',
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a raça do pet.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickBirthDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento *',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                child: Text(
                  _birthDate == null
                      ? 'Toque para selecionar'
                      : _dateFormat.format(_birthDate!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Peso (kg) *',
                prefixIcon: Icon(Icons.monitor_weight_outlined),
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o peso do pet.';
                }
                final double? parsed =
                    double.tryParse(value.trim().replaceAll(',', '.'));
                if (parsed == null) {
                  return 'Informe um número válido.';
                }
                if (parsed <= 0) {
                  return 'O peso deve ser maior que zero.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<VaccinationStatus>(
              initialValue: _vaccinationStatus,
              decoration: const InputDecoration(
                labelText: 'Vacinação em dia? *',
                prefixIcon: Icon(Icons.vaccines_outlined),
              ),
              items: VaccinationStatus.values
                  .map(
                    (VaccinationStatus status) =>
                        DropdownMenuItem<VaccinationStatus>(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(),
              onChanged: (VaccinationStatus? value) {
                if (value != null) {
                  setState(() => _vaccinationStatus = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações',
                prefixIcon: Icon(Icons.note_alt_outlined),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isSubmitting ? 'Salvando...' : 'Salvar pet'),
            ),
          ],
        ),
      ),
    );
  }
}
