import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lunch_vote/controller/profile_controller.dart';
import 'package:lunch_vote/styles.dart';
import 'package:lunch_vote/view/screen/login_screen.dart';
import 'package:lunch_vote/view/widget/appbar_widget.dart';
import 'package:lunch_vote/view/widget/custom_clip_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = ProfileController();
  bool _nicknameChange = false;

  final TextEditingController _nickNameController = TextEditingController();
  String _nickname = "";

  final _formKey = GlobalKey<FormState>();

  late Future future;

  @override
  void initState() {
    super.initState();
    future = _profileController.getProfileInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BasicAppbar(
        backVisible: true,
        appbarTitle: "마이페이지",
        isTitleCenter: true,
        context: context,
        trailingList: null,
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.data == null){
                return const Center(child: CircularProgressIndicator());
              }
              else {
                _nickname = snapshot.data!.nickname;
                return Stack(
                  children: [
                    ClipPath(
                      clipper: CustomClipPath(),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: double.infinity,
                        height: double.infinity,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .surfaceVariant,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                    snapshot.data!.profileImage),
                                  radius: 100,
                                ),
                              ]
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _nickname,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                        Visibility(
                          visible: !_nicknameChange,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _nicknameChange = !_nicknameChange;
                                });
                              },
                              child: const Text(
                                '닉네임 수정',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textHintColor,
                                    decoration: TextDecoration.underline),
                              )),
                        ),
                        Visibility(
                            visible: _nicknameChange,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: TextFormField(
                                controller: _nickNameController,
                                decoration: InputDecoration(
                                    labelText: '변경할 닉네임을 입력하세요.',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_nickNameController.text
                                                .isEmpty) {
                                              _nicknameChange = false;
                                            } else {
                                              _nickNameController.text = '';
                                            }
                                          });
                                        },
                                        icon: Icon(Icons.close,
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary,))
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '닉네임을 입력해주세요.';
                                  } else
                                  if (value.length < 2 || value.length > 8) {
                                    return '닉네임 길이를 2~8로 해주세요.';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  setState(() {
                                    _nickname = value!;
                                  });
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _nicknameChange,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 90),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _profileController
                                  .changeNickname(_nickname)
                                  .then((value) {
                                String complete = value != null ? '성공' : '실패';
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '닉네임 변경에 $complete 하였습니다.')));
                                setState(() {
                                  _nicknameChange = false;
                                  // future 재선언 하여 프로필 정보 리로드
                                  future = _profileController.getProfileInfo();
                                });
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              padding: const EdgeInsets.fromLTRB(
                                  24, 10, 24, 10)),
                          child: Text(
                            '설정 완료',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    Visibility(
                        visible: !_nicknameChange,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 90),
                            child: ElevatedButton(
                              onPressed: () async {
                                bool res = await _showDialog();
                                if (res){
                                  _profileController.logout();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) =>
                                          const LoginScreen()), (route) => false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10)),
                              child: const Text("로그아웃")
                              )
                            ),
                          ),
                        )
                  ],
              );
            }
            }
          ),
        ),
      ),
    );
  }

  Future<bool> _showDialog() async{
    bool? canExit;
    AwesomeDialog dlg = AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: "로그아웃",
      desc: "정말로 로그아웃 하시겠습니까?",
      dismissOnTouchOutside: true,
      btnCancelOnPress: () => canExit = false,
      btnOkOnPress: () => canExit = true,
      btnOkText: "예",
      btnCancelText: "아니요",

    );
    await dlg.show();

    return Future.value(canExit);
  }
}
