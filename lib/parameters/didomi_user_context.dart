/// Optional context forwarded to the native SDK.
class DidomiUserContext {
  Map<String, String>? attributes;
  Map<String, String>? variables;
  int? age;
  bool? isLoggedIn;

  DidomiUserContext(
      {this.attributes, this.variables, this.age, this.isLoggedIn});

  Map<String, dynamic> toJson() => {
        if (attributes != null) 'attributes': attributes,
        if (variables != null) 'variables': variables,
        if (age != null) 'age': age,
        if (isLoggedIn != null) 'isLoggedIn': isLoggedIn,
      };
}
