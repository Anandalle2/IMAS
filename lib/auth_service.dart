import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  static final auth =
      FirebaseAuth.instance;

  static Future<bool> signup(

      String email,

      String password,

      String fullName,

      ) async {

    try{

      UserCredential user=

      await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(

        email:email,

        password:password,
      );

      await user.user!
          .updateDisplayName(

        fullName,
      );

      await user.user!
          .reload();

      return true;

    }

    catch(e){

      print(e);

      return false;

    }
  }

  static Future<bool> login(

      String email,

      String password)

  async{

    try{

      await auth
          .signInWithEmailAndPassword(

          email:
          email,

          password:
          password
      );

      return true;

    }catch(e){

      return false;
    }
  }

  static Future<bool> googleLogin() async {

    try{

      final GoogleSignIn googleSignIn =
          GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount user =

      await googleSignIn.authenticate();

      final authentication =

          user.authentication;

      final credential =

      GoogleAuthProvider.credential(

        accessToken:null,

        idToken:
        authentication.idToken,
      );

      await auth
          .signInWithCredential(
          credential);

      return true;

    }

    catch(e){

      print(e);

      return false;
    }
  }

  static Future logout()
  async{

    await auth.signOut();
  }

  static Future resetPassword(
      String email)

  async{

    await auth
        .sendPasswordResetEmail(

        email:
        email
    );
  }
}