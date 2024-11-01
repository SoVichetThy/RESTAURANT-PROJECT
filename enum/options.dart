enum options {
  Dine_in("Dine-in"),
  Take_out("Take-out"),
  Admin("admin"),
  Exit("Exit");

  final String optionLabel;

  const options(this.optionLabel);

  String toString() {
    return switch (this) {
      options.Dine_in => optionLabel,
      options.Take_out => optionLabel,
      options.Admin => optionLabel,
      options.Exit => optionLabel,
    };
  }
}
