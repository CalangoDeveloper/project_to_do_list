import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      home: ChecklistScreen(),
    );
  }
}


class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}


class _ChecklistScreenState extends State<ChecklistScreen> {
  List<Activity> _toDoActivities = [];
  List<Activity> _inProgressActivities = [];
  List<Activity> _doneActivities = [];
  String _newActivityTitle = '';
  ActivityStatus? _selectedStatus;


  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirme o nome da tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
               
                onChanged: (text) {
                  setState(() {
                    _newActivityTitle = text;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButton<ActivityStatus>(
                value: _selectedStatus,
                hint: Text('Selecione o status'),
                items: [
                  DropdownMenuItem<ActivityStatus>(
                    child: Text('A Fazer'),
                    value: ActivityStatus.toDo,
                  ),
                  DropdownMenuItem<ActivityStatus>(
                    child: Text('Fazendo'),
                    value: ActivityStatus.inProgress,
                  ),
                  DropdownMenuItem<ActivityStatus>(
                    child: Text('Feito'),
                    value: ActivityStatus.done,
                  ),
                ],
                onChanged: (ActivityStatus? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newActivityTitle.isNotEmpty && _selectedStatus != null) {
                  setState(() {
                    Activity newActivity = Activity(_newActivityTitle, _selectedStatus!);
                    switch (_selectedStatus) {
                      case ActivityStatus.toDo:
                        _toDoActivities.add(newActivity);
                        break;
                      case ActivityStatus.inProgress:
                        _inProgressActivities.add(newActivity);
                        break;
                      case ActivityStatus.done:
                        _doneActivities.add(newActivity);
                        break;
                      default:
                        break;
                    }
                    _newActivityTitle = '';
                    _selectedStatus = null;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }


  void _navigateToArchivedScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArchivedScreen(_doneActivities),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                   
                    labelText: 'Qual a sua tarefa',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _newActivityTitle = text;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _showAddTaskDialog,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                ),
                child: Text('Nova'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildStatusSection('A Fazer', _toDoActivities),
                _buildStatusSection('Em Andamento', _inProgressActivities),
                _buildStatusSection('Feito', _doneActivities),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToArchivedScreen,
        child: Icon(Icons.archive),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }


  Widget _buildStatusSection(String title, List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(activities[index].title),
            );
          },
        ),
      ],
    );
  }
}


class ArchivedScreen extends StatelessWidget {
  final List<Activity> archivedActivities;


  ArchivedScreen(this.archivedActivities);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atividades Arquivadas'),
        backgroundColor: Colors.blue,
      ),
      body: archivedActivities.isEmpty
       ? Center(
            child: Text('Nenhuma atividade arquivada'),
          )
        : ListView.builder(
            itemCount: archivedActivities.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(archivedActivities[index].title),
              );
            },
          ),
    );
  }
}


enum ActivityStatus { toDo, inProgress, done }


class Activity {
  String title;
  ActivityStatus status;
  Activity(this.title, this.status);
}