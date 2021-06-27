import 'package:flutter/material.dart';
import 'package:induction_motor_torque_charts/routes/router_delegate.dart';
import 'package:faker/faker.dart' as faker;
import '../models/motor.dart';

extension NumberParser on String {
  num get numParse => num.parse(this);
  int get intParse => int.parse(this);
  double get doubleParse => double.parse(this);
}

class MotorEditorScreen extends StatefulWidget {
  const MotorEditorScreen({this.motor, Key? key}) : super(key: key);

  final Motor? motor;

  @override
  _MotorEditorScreenState createState() => _MotorEditorScreenState();
}

class _MotorEditorScreenState extends State<MotorEditorScreen> {
  final _name = TextEditingController(
      text: faker.faker.lorem
          .words(2)
          .reduce((value, element) => value + ' ' + element));
  final _pn = TextEditingController();
  final _vl = TextEditingController(text: '220');
  final _f = TextEditingController(text: '60');
  final _p = TextEditingController(text: '2');
  final _r1 = TextEditingController();
  final _x1 = TextEditingController();
  final _xm = TextEditingController();
  final _r2 = TextEditingController();
  final _x2 = TextEditingController();
  String _selectedUnity = 'kW';
  static const _powerUnits = <String, double>{
    'kW': 1000,
    'cv': 735.499,
    'hp': 745.7,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Motor'),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Divider(),
              Text('Nome do registro'),
              Divider(),
              _buildField(controller: _name, label: 'Nome'),
              Divider(),
              Text('Especificações do motor'),
              Divider(),
              Container(
                constraints: BoxConstraints(maxWidth: 360),
                child: Row(children: [
                  Expanded(
                    child: _buildField(controller: _pn, label: 'Potência'),
                  ),
                  Container(
                    child: DropdownButton<String>(
                        value: _selectedUnity,
                        onTap: () {},
                        onChanged: (v) => setState(() => v != null
                            ? _selectedUnity = v
                            : _selectedUnity = _selectedUnity),
                        items: _powerUnits.keys
                            .map<DropdownMenuItem<String>>((e) =>
                                DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                  onTap: () => setState(() => _selectedUnity = e),
                                ))
                            .toList()),
                    width: 50,
                  ),
                ]),
              ),
              _buildField(
                  controller: _f, label: 'frequência da rede', unity: 'Hz'),
              _buildField(controller: _p, label: 'número de polos'),
              _buildField(
                  controller: _vl, label: 'Tensão de linha', unity: 'V'),
              Divider(),
              Text('Parâmetros do modelo'),
              Divider(),
              _buildField(controller: _r1, label: 'R1', unity: 'Ω'),
              _buildField(controller: _x1, label: 'X1', unity: 'Ω'),
              _buildField(controller: _xm, label: 'Xm', unity: 'Ω'),
              _buildField(controller: _r2, label: 'R2', unity: 'Ω'),
              _buildField(controller: _x2, label: 'X2', unity: 'Ω'),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _save,
      ),
    );
  }

  void _save() {
    final _router = AppRouterDelegate.of(context);
    try {
      final motorEntry = Motor(
        name: _name.text,
        Pn: _pn.text.numParse * _powerUnits[_selectedUnity]!,
        p: _p.text.intParse,
        f: _f.text.numParse,
        Vl: _vl.text.numParse,
        R1: _r1.text.numParse,
        X1: _x1.text.numParse,
        Xm: _xm.text.numParse,
        R2: _r2.text.numParse,
        X2: _x2.text.numParse,
      );

      int index = _router.saveMotor(motorEntry);
      _router.popRoute();
      _router.selectMotor(index);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro ao ler os dados!'),
          content: Text(
              'Certifique-se de ter escrito os valores numéricos corretamente. Utilize PONTO para a casa decimal.'),
          actions: [
            ElevatedButton(onPressed: _router.popRoute, child: Text('OK :('))
          ],
        ),
      );
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    final unity,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 360),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffix: unity == null ? null : Text(unity),
        ),
      ),
    );
  }
}
