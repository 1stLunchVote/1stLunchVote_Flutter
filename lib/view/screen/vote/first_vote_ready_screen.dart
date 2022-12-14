import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/appbar_widget.dart';
import '../../widget/custom_clip_path.dart';
import 'first_vote_screen.dart';

class FirstVoteReadyScreen extends StatelessWidget {
  String groupId;

  FirstVoteReadyScreen({
    Key? key,
    required this.groupId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        backVisible: false,
        appbarTitle: "투표 1단계 - 선호&비선호",
        isTitleCenter: false,
        context: context,
        trailingList: [
          IconButton(
              onPressed: (){

              },
              icon: const Icon(Icons.more_vert)
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 230.h,),
                  Text(
                    'Tips!',
                    style: TextStyle(fontSize: 24.sp, color: Colors.black),
                  ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: '한 번 클릭하면 ', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                          TextSpan(text: '먹고 싶은 음식', style: TextStyle(fontSize: 16.sp, color: Colors.green)),
                          TextSpan(text: '으로,', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                        ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: '두 번 클릭하면 ', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                          TextSpan(text: '먹기 싫은 음식', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
                          TextSpan(text: '으로,', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                        ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: '세 번 클릭하면 선택이 해제됩니다!', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                        ]
                    ),
                  ),
                  SizedBox(height: 160.h),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FirstVoteScreen(groupId: groupId))
                      );
                    },
                    child: const Text(
                      '투표시작!',
                      style: TextStyle(
                        color: Color.fromRGBO(161, 63, 36, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
