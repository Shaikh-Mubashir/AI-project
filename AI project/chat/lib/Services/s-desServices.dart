import 'dart:math';

class SDESServices {
  List<String> keyGeneration(String key) {
    print("entering in key gen");
    List<String> ks = [];
    //applying p10
    String p10Otp = applyP10(key);
    int length = p10Otp.length;
    int mid = length ~/ 2;
    String left = p10Otp.substring(0, mid);
    String right = p10Otp.substring(mid, length);
    //apply ls 1
    left = leftShift1(left);
    right = leftShift1(right);
    //apply p8
    String p8Otp = applyP8(left + right);

    ks.add(p8Otp);

    //apply ls 2
    left = leftShift2(left);
    right = leftShift2(right);

    //apply p8
    p8Otp = applyP8(left + right);
    ks.add(p8Otp);

    return ks;
  }

  List<String> sDesEncryption(String pt, String k1, String k2) {
    List<String> binary = convertStringToBinary(pt);
    List<String> cipherText = [];
    for (var data in binary) {
      print('Data------$data');
      //apply IP
      String ipOtp = applyIP(data);
      int length = ipOtp.length;
      int mid = length ~/ 2;
      String left = ipOtp.substring(0, mid);
      String right = ipOtp.substring(mid, length);

      ///Round 1
      //ep
      String epOtp = applyEP(right);

      //xor with k1
      String xorOtp = XOR(epOtp, k1);

      length = xorOtp.length;
      mid = length ~/ 2;
      String xorLeft = xorOtp.substring(0, mid);
      String xorRight = xorOtp.substring(mid, length);
      //applying s0 and s1
      String s0Result = applys0(xorLeft);

      String s1Result = applys1(xorRight);

      //applying P4
      String p4Result = applyP4(s0Result + s1Result);

      //XOR with left
      String result = XOR(p4Result, left);

      ///swapping
      String swapResult = right + result;
      length = swapResult.length;
      mid = length ~/ 2;

      ///Round 2
      left = swapResult.substring(0, mid);
      right = swapResult.substring(mid, length);

      //applying EP
      epOtp = applyEP(right);

      //XOR with k2
      xorOtp = XOR(epOtp, k2);
      length = xorOtp.length;
      mid = length ~/ 2;
      xorLeft = xorOtp.substring(0, mid);
      xorRight = xorOtp.substring(mid, length);

      //applying s0 and s1
      s0Result = applys0(xorLeft);

      s1Result = applys1(xorRight);

      //applying P4
      p4Result = applyP4(s0Result + s1Result);
      //XOR with left
      result = XOR(p4Result, left);
      //applying Ip inverse
      cipherText.add(applyIpInv(result + right));
    }

    return cipherText;
  }

  List<String> sDesDecryption(String pt, String k1, String k2) {
    List<String> binary = convertStringToBinary(pt);
    List<String> cipherText = [];
    print('length: ${pt.length}');
    for (var data in binary) {
      print('Data------$data');
      //apply IP
      String ipOtp = applyIP(data);
      int length = ipOtp.length;
      int mid = length ~/ 2;
      String left = ipOtp.substring(0, mid);
      String right = ipOtp.substring(mid, length);

      ///Round 2
      //applying EP
      String epOtp = applyEP(right);

      //XOR with k2
      String xorOtp = XOR(epOtp, k2);
      length = xorOtp.length;
      mid = length ~/ 2;
      String xorLeft = xorOtp.substring(0, mid);
      String xorRight = xorOtp.substring(mid, length);

      //applying s0 and s1
      String s0Result = applys0(xorLeft);

      String s1Result = applys1(xorRight);

      //applying P4
      String p4Result = applyP4(s0Result + s1Result);
      //XOR with left
      String result = XOR(p4Result, left);

      ///swapping
      String swapResult = right + result;
      length = swapResult.length;
      mid = length ~/ 2;
      left = swapResult.substring(0, mid);
      right = swapResult.substring(mid, length);

      ///Round 1
      //ep
      epOtp = applyEP(right);

      //xor with k1
      xorOtp = XOR(epOtp, k1);

      length = xorOtp.length;
      mid = length ~/ 2;
      xorLeft = xorOtp.substring(0, mid);
      xorRight = xorOtp.substring(mid, length);
      //applying s0 and s1
      s0Result = applys0(xorLeft);

      s1Result = applys1(xorRight);

      //applying P4
      p4Result = applyP4(s0Result + s1Result);

      //XOR with left
      result = XOR(p4Result, left);

      //applying Ip inverse
      cipherText.add(applyIpInv(result + right));
    }

    return cipherText;
  }

  String applys0(String a) {
    List<List<int>> s0 = [
      [1, 0, 3, 2],
      [3, 2, 1, 0],
      [0, 2, 1, 3],
      [3, 1, 3, 2]
    ];
    int row = int.parse("${a[0]}${a[3]}", radix: 2);
    int column = int.parse("${a[1]}${a[2]}", radix: 2);

    int result = s0[row][column];
    String binary = result.toRadixString(2);

    if (binary == "0") {
      binary = "00";
    } else if (binary == "1") {
      binary = "01";
    }
    // else if (binary == "2") {
    //   binary = "10";
    // }

    else {
      binary = binary;
    }
    return binary;
  }

  String applys1(String a) {
    List<List<int>> s1 = [
      [0, 1, 1, 3],
      [2, 0, 1, 3],
      [3, 0, 1, 0],
      [2, 1, 0, 3]
    ];

    int row = int.parse("${a[0]}${a[3]}", radix: 2);
    int column = int.parse("${a[1]}${a[2]}", radix: 2);
    int result = s1[row][column];
    String binary = result.toRadixString(2);
    if (binary == "0") {
      binary = "00";
    } else if (binary == "1") {
      binary = "01";
    }
    // else if (binary == "2") {
    //   binary = "10";
    // }
    else {
      binary = binary;
    }

    return binary;
  }

  List<String> convertStringToBinary(String s) {
    List<String> bytes = [];
    for (int i = 0; i < s.length; i++) {
      print('printing:- ${s[i]}');
      var abc = s.codeUnitAt(i).toRadixString(2);
      if (abc.length > 7) {
        print('in if');
        bytes.add(abc);
      } else {
        print('in else');
        bytes.add("0" + abc);
      }
    }
    print("Bytres----$bytes");
    return bytes;
  }

  String XOR(String a, String b) {
    String xorValue = "";
    for (int i = 0; i < a.length; i++) {
      if (a[i] == b[i]) {
        xorValue = xorValue + "0";
      } else {
        xorValue = xorValue + "1";
      }
    }

    return xorValue;
  }

  String leftShift1(String value) {
    List<String> list = value.split('');
    String check = list.removeAt(0);
    list.add(check);
    String a = "";
    list.forEach((value) {
      a = a + value;
    });

    return a;
  }

  String leftShift2(String value) {
    String a = leftShift1(value);
    a = leftShift1(a);
    return a;
  }

  String applyP8(String a) {
    //637485 10 9
    //52637498
    return a[5] + a[2] + a[6] + a[3] + a[7] + a[4] + a[9] + a[8];
  }

  String applyP10(String a) {
    //35274 10 1986
    //2416390875
    return a[2] + a[4] + a[1] + a[6] + a[3] + a[9] + a[0] + a[8] + a[7] + a[5];
  }

  String applyP4(String a) {
    //2431
    //1320
    return a[1] + a[3] + a[2] + a[0];
  }

  String applyEP(String a) {
    //41232341
    //30121230
    return a[3] + a[0] + a[1] + a[2] + a[1] + a[2] + a[3] + a[0];
  }

  String applyIP(String a) {
    //26314857
    //15202746
    return a[1] + a[5] + a[2] + a[0] + a[3] + a[7] + a[4] + a[6];
  }

  String applyIpInv(String a) {
    //41357286
    //30246175
    return a[3] + a[0] + a[2] + a[4] + a[6] + a[1] + a[7] + a[5];
  }
}
