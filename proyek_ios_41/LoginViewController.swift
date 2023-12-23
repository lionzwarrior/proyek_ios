import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var inputUsernameorEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    var userAccountList: [Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ambil array akun yang sudah ada dari UserDefaults
        if let savedAccountsData = UserDefaults.standard.data(forKey: "accounts"),
           let savedAccounts = try? JSONDecoder().decode([Account].self, from: savedAccountsData) {
            userAccountList = savedAccounts
        }
    }

    // Saat button Login ditekan
    @IBAction func btnLoginTapped(_ sender: Any) {
        // Validasi input data
        guard let usernameOrEmail = inputUsernameorEmail.text, !usernameOrEmail.isEmpty,
              let password = inputPassword.text, !password.isEmpty else {
            print("Harap lengkapi semua data")
            return
        }

        // Cari akun yang sesuai berdasarkan username atau email
        if let matchedAccount = findAccount(usernameOrEmail: usernameOrEmail) {
            // Verifikasi kata sandi
            if matchedAccount.password == password {
                print("Login berhasil!")
                performSegue(withIdentifier: "moveToMain", sender: nil)
            } else {
                print("Kata sandi salah")
            }
        } else {
            print("Akun tidak ditemukan")
        }
    }

    // Fungsi untuk mencari akun berdasarkan username atau email
    func findAccount(usernameOrEmail: String) -> Account? {
        let lowercaseInput = usernameOrEmail.lowercased()

        // Cari akun yang sesuai
        for account in userAccountList {
            if account.username.lowercased() == lowercaseInput || account.email.lowercased() == lowercaseInput {
                return account
            }
        }

        return nil
    }
}
