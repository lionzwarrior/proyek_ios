import UIKit

// Untuk bentuk data Objek User
class Account: Codable {
    var email: String
    var username: String
    var password: String

    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
    }
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let ud = UserDefaults.standard
    var userAccountList: [Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cek apakah UserDefaults untuk key "accounts" sudah dibuat
        if let savedAccountsData = ud.data(forKey: "accounts"),
           let savedAccounts = try? JSONDecoder().decode([Account].self, from: savedAccountsData) {
            // Jika sudah ada, gunakan savedAccounts
            userAccountList = savedAccounts
        }
    }
    
    // Saat button SignUp ditekan
    @IBAction func btnSignUpTapped(_ sender: Any) {
        // Validasi input data
        guard let email = inputEmail.text, !email.isEmpty,
              let username = inputUsername.text, !username.isEmpty,
              let password = inputPassword.text, !password.isEmpty else {
                print("Harap lengkapi semua data")
                return
        }
        
        // Buat objek akun baru
        let newAccount = Account(email: email, username: username, password: password)
        
        // Tambahkan akun baru ke dalam array
        userAccountList.append(newAccount)
        
        // Simpan array akun ke UserDefaults
        if let encodedData = try? JSONEncoder().encode(userAccountList) {
            ud.set(encodedData, forKey: "accounts")
            print("Pendaftaran berhasil!")
            performSegue(withIdentifier: "moveToLoginPage", sender: nil)
        } else {
            print("Gagal menyimpan data akun.")
        }
    }
}
