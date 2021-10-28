// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:kuwait_livestock/Module/CommentModel.dart';
// import 'package:kuwait_livestock/provider/provider.dart';
// import 'package:provider/provider.dart';
//
// class CommentCard extends StatelessWidget {
//   final id ;
//   CommentCard({this.id});
//   @override
//   Widget build(BuildContext context) {
//     var pro = Provider.of<AppProvider>(context);
//     pro.getproductDetails(id);
//     return ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount:pro.CommentList.length,
//           itemBuilder: (context, index) {
//
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 elevation: 4,
//                 borderOnForeground: true,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${pro.CommentList[index].author_id[1]}'),
//                       Text('${pro.CommentList[index].body}'),
//
//                       RatingBar.builder(
//                         initialRating:1 ,
//                         itemSize: 25,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemPadding: EdgeInsets.symmetric(
//                           horizontal: 1,
//                         ),
//                         itemBuilder: (context, _) => Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                         ),
//                         onRatingUpdate: (rating) {
//
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//
//       },
//
//     );
//   }
// }
