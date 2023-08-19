import 'package:courier_management_system/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/components/round_button.dart';
import '../utils/utils.dart';
import '../view_model/auth_view_model.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {


ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

FocusNode emailFocusNode = FocusNode();
FocusNode passwordFocusNode = FocusNode();

@override
void dispose() {
  // TODO: implement dispose
  super.dispose();
  _emailController.dispose();
  _passwordController.dispose();

  emailFocusNode.dispose();
  passwordFocusNode.dispose();

  _obscurePassword.dispose();
}
@override
Widget build(BuildContext context) {
  final authViewModel = Provider.of<AuthViewModel>(context);

  final height = MediaQuery.of(context).size.height * 1;
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      backgroundColor: Colors.teal,
      centerTitle: true,
      title: Text('Sign Up'),
    ),
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            focusNode: emailFocusNode,
            decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.alternate_email),
                labelText: 'Email'),
            onFieldSubmitted: (value) {
              Utils.fieldFocusChange(
                  context, emailFocusNode, passwordFocusNode);
            },
          ),

          ValueListenableBuilder(
              valueListenable: _obscurePassword,
              builder: (context, value, child) {
                return TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: _obscurePassword.value,
                  focusNode: passwordFocusNode,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: InkWell(
                          onTap: () {
                            _obscurePassword.value = !_obscurePassword.value;
                          },
                          child: Icon(_obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_open_rounded)),
                  onFieldSubmitted: (value) {},
                  validator: (e) {
                    return 'Enter Email';
                  },
                );
              }),
          SizedBox(
            height: height * .1,
          ),

          RoundButton(
              title: 'Sign Up',
              loading: authViewModel.signUpLoading,
              onPress: () {
                if(_emailController.text.isEmpty){
                  Utils.snackBar('Please Enter Email', context);
                }else if(_passwordController.text.isEmpty){
                  Utils.snackBar('Please Enter Your Password', context);
                }else if(_passwordController.text.length < 6 ){
                  Utils.snackBar('Please Enter 6 digit Password', context);

                }else{
                  Map data = {
                    'email': _emailController.text.toString(),
                    'password': _passwordController.text.toString()
                  };
                  authViewModel.signUpApi(data, context);
                  print('Api Hit');

                }


              }),

          SizedBox(
            height: height * .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Already have an account?'),

              SizedBox(
                width: 5,
              ),
              InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RoutesName.login);

                  },
                  child: Text('Login', style: TextStyle(color: Colors.lightBlue,fontSize: 14)),)

            ],)

          // Center(
          //   child: InkWell(
          //       onTap: () {
          //         // USING FLUSH BAR
          //         Utils.flushBarErrorMessage('No internet Connection', context);
          //
          //         //USING FLUTTER TOAST
          //         Utils.toastMessage('Moved Successfully');
          //         Navigator.pushNamed(context, RoutesName.home);
          //
          //         // USING SNACKBAR
          //         Utils.snackBar('No iNternet Connection', context);
          //       },
          //       child: Text('Click')),
        ],
      ),
    ),
  );
}
}
