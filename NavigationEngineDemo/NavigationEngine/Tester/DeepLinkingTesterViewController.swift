//
//  DeepLinkingTesterViewController.swift
//  JUSTEAT
//
//  Created by Shabeer Hussain on 22/11/2018.
//  Copyright © 2018 JUST EAT. All rights reserved.
//

import UIKit

public protocol DeepLinkingTesterViewControllerDelegate: class {
    func deepLinkingTesterViewController(_ deepLinkingTesterViewController: DeepLinkingTesterViewController, didSelect url: URL)
}

public class DeepLinkingTesterViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quickLinksLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var linkTypeSelector: UISegmentedControl!
    
    public weak var delegate: DeepLinkingTesterViewControllerDelegate?
    
    public func loadTestLinks(atPath filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        let fileContent = try! Data(contentsOf: url)
        let jsonObject = try! JSONSerialization.jsonObject(with: fileContent, options: []) as! [String: Any]
        universalLinks = jsonObject["universal_links"] as? [String]
        deepLinks = jsonObject["deep_links"] as? [String]
    }
    
    private var currentLinks: [String]!
    private var universalLinks: [String]!
    private var deepLinks: [String]!
    
    public static func instantiate() -> DeepLinkingTesterViewController {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "DeepLinkingTester", bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: className) as! DeepLinkingTesterViewController
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        applyLocalisation()
        currentLinks = universalLinks
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func applyLocalisation() {
        title = "DeepLinking Tester"
        urlTextField.placeholder = "https://yourdomain.com/"
        descriptionLabel.text = "Enter a URL and test how the app handles it"
    }
    
    private func sanitisedUniversalLink(from universalLink: String?) -> URL? {
        guard
            let text = universalLink,
            text.count > 0,
            let url = URL(string: text)
            else { return nil }
        
        return url
    }
}

extension DeepLinkingTesterViewController {
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let url = sanitisedUniversalLink(from: urlTextField.text) else { return }
        delegate?.deepLinkingTesterViewController(self, didSelect: url)
    }
    
    @IBAction public func segmentedControlDidSelect(sender: UISegmentedControl) {
        let selectedIndex = linkTypeSelector.selectedSegmentIndex
        currentLinks = (selectedIndex == 0 ? universalLinks : deepLinks)
        urlTextField.placeholder = (selectedIndex == 0 ? "https://yourdomain.com/" : "your-scheme://")
        tableView.reloadData()
    }
}

extension DeepLinkingTesterViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quickLink = currentLinks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = quickLink
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentLinks.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        urlTextField.text = currentLinks[indexPath.row]
    }
}
