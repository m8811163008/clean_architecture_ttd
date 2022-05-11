int cycle(int n) {
  // n
  double result = 1 / n;
  //read every digit of decimal
  List resultList = result.toString().substring(2).split('');
  print(resultList);

  return 0;
}

void main() {
  cycle(2);
}
