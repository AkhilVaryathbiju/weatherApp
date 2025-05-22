import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temparature;

  const HourlyForecast({super.key,
  required this.time,
  required this.icon,
  required this.temparature});

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 7,
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(8.0),
                      child:  Column(
                        children: [
                          Text(time ,style: TextStyle(fontSize: 17,
                          fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 8,),
                          Icon(icon),
                           SizedBox(height: 8,),
                          Text(temparature)
                        ],
                      ),
                    ),
                  ) ;
  }
}