import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Additional_information.dart';
import 'package:weatherapp/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/secrets.dart';
class WeatherhomePage extends StatefulWidget {
  const WeatherhomePage({super.key});

  @override
  State<WeatherhomePage> createState() => _WeatherhomePageState();
}

class _WeatherhomePageState extends State<WeatherhomePage> {
  late Future<Map<String,dynamic>> weather;
  
  

Future<Map<String,dynamic>> getCurrentWeather()async{
  try{
  String cityName='London';
  
  final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'));
  
  final data=  jsonDecode(res.body);
  
  if(data['cod']!='200'){
    throw 'An unexpected error occured';
  }
  
  return data;
  //  temp = data['main']['temp'];
  

  }catch (e) {
    throw e.toString();
  }

}
@override
  void initState() {
    
    super.initState();
    weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',
        style: TextStyle(
          fontSize: 32
        ),
        ),
        centerTitle: true,
      actions: [
        IconButton(onPressed: (){
          setState(() {
            weather=getCurrentWeather();
          });
        },
         icon:Icon(Icons.refresh))
      ],
      ),
      body:  FutureBuilder(
        future: weather,
        builder: (context,snapshot) {
         
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          final data=snapshot.data!;
          final currentWeatherdata=data['list'][0];
          final currentTemparature= currentWeatherdata['main']['temp'];
          final currentSky=currentWeatherdata['weather'][0]['main'];
          final pressure=currentWeatherdata['main']['pressure'];
          final wind=currentWeatherdata['wind']['speed'];
          final humidity=currentWeatherdata['main']['humidity'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                           
                        ),
                        child:  Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('$currentTemparature K ',style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              SizedBox(height: 16,),
                              Icon(currentSky =='Clouds' || currentSky == 'Rain'?
                                Icons.cloud : Icons.sunny,
                              size: 64,),
                               SizedBox(height: 16,),
                              Text('$currentSky',style: TextStyle(
                                fontSize: 20
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
           const   SizedBox(height: 20,),
           const   Text(' Weather Forecasts',
              style: TextStyle(
                fontSize: 24
              ),
              ),
          const    SizedBox(height: 15,),

              SizedBox(height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    final HourlyForecastt=data['list'][index + 1]; 
                    final time=DateTime.parse(HourlyForecastt['dt_txt'].toString());
                    return HourlyForecast(time:DateFormat.j().format(time) ,
                    
                     icon: HourlyForecastt['weather'][0]['main']=='Clouds'||data['list'][index+1]['weather'][0]['main']=='Rain' ?
                
                      Icons.cloud : Icons.sunny,
                   
                      temparature: HourlyForecastt['main']['temp'].toString());
                
                }),
              ),
            
               const SizedBox(height: 20,),
              Text(' Additional information',
              style: TextStyle(
                fontSize: 24
              ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                              AdditionalInformation(
                                icon: Icons.water_drop,
                                label: 'Humidity',
                                value: humidity.toString(),
                              ),
              AdditionalInformation(
                icon: Icons.air,
                label: 'Wind speed',
                value: wind.toString(),
              ),
              AdditionalInformation(
                icon: Icons.beach_access,
                label: 'Pressure',
                value: pressure.toString(),
              )
                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}
