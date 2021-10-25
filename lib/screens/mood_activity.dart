import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymentalhealth/helpers/db_helper.dart';
import 'package:mymentalhealth/helpers/mood_data.dart';
import 'package:mymentalhealth/models/moodcard.dart';
import 'package:mymentalhealth/widgets/mood_activity.dart';
import 'package:provider/provider.dart';

class MoodActivityScreen extends StatefulWidget {
  const MoodActivityScreen({Key? key}) : super(key: key);

  @override
  _MoodActivityScreenState createState() => _MoodActivityScreenState();
}

class _MoodActivityScreenState extends State<MoodActivityScreen> {
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    loader = Provider.of<MoodCard>(context, listen: true).isLoading;
    return loader
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text('Your Moods'),
              backgroundColor: Colors.blue,
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.show_chart),
                    onPressed: () => Navigator.of(context).pushNamed('/chart'))
              ],
            ),
            body: FutureBuilder<List>(
              future: DBHelper.getData('user_moods'),
              initialData: List.filled(0, null, growable: true),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? moodActivity(snapshot)
                    : const Center(child: CircularProgressIndicator());
              },
            ),
          );
  }

  ListView moodActivity(AsyncSnapshot<List<dynamic>> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data?.length,
      itemBuilder: (context, int position) {
        return getMoodActivityItem(snapshot, position, context);
      },
    );
  }

  MoodActivity getMoodActivityItem(AsyncSnapshot<List<dynamic>> snapshot,
      int position, BuildContext context) {
    var imageString = snapshot.data?[position]['actimage'];
    List<String> img = imageString.split('_');
    List<String> name = snapshot.data?[position]['actname'].split("_");
    Provider.of<MoodCard>(context, listen: false).activityNames.addAll(name);
    Provider.of<MoodCard>(context, listen: false).data.add(MoodData(
        snapshot.data?[position]['mood'], snapshot.data?[position]['date']));
    return MoodActivity(
        snapshot.data?[position]['image'],
        snapshot.data?[position]['datetime'],
        snapshot.data?[position]['mood'],
        img,
        name);
  }
}