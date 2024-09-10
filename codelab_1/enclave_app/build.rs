fn main() {
  println!("cargo:rustc-link-arg=-zmax-page-size=0x200000");
}