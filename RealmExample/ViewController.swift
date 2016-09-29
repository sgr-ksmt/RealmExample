//
//  ViewController.swift
//  RealmExample
//
//  Created by Suguru Kishimoto on 9/29/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    var randomTexts: [String] = [
        "今日の天気は晴れ。伊東の砂浜から見る景色は綺麗だった",
        "今日の天気は雨。でも気温が高くてジメジメしててつらい",
        "今日は久々の休日。一日ゆっくり寝て静養する",
    ]
    
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate lazy var realm = try! Realm()
    private var token: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        autoreleasepool {
            let realm = try! Realm()
            let tag = Tag()
            tag.name = "Diary"
            try! realm.write {
                realm.add(tag, update: true)
            }
        }
        navigationItem.rightBarButtonItem = self.addButton()
        
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.rowHeight = 44.0
        self.token = realm.addNotificationBlock { _ in
            DispatchQueue.main.async { [weak self] in
                self?.updateTitle()
            }
        }
        updateTitle()
    }
    
    func updateTitle() {
        let tag = realm.objects(Tag.self).first!
        navigationItem.title = "\(tag.name): \(tag.blogs.count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func addButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(add(_:)))
    }
    
    @objc private func add(_: UIBarButtonItem) {
        let blog = Blog(title: "タイトル", content: randomTexts[Int(arc4random_uniform(UInt32(randomTexts.count)))])
        try! realm.write {
            let tag = realm.objects(Tag.self).first!
            tag.blogs.append(blog)
            realm.add(blog)
        }
        
        let count = realm.objects(Blog.self).count
        if count > 0 {
            tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .bottom)
        } else {
            tableView.reloadData()
        }
    }
    deinit {
        token?.stop()
        self.token = nil
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Blog.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blog = realm.objects(Blog.self).sorted(byProperty: "createdAt", ascending: false).first!
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        cell.textLabel?.text = "\(blog.title)\n\(blog.content)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
