//
//  ContentView.swift
//  JobHuntingManager
//
//  Created by 竹井佑騎 on 2026/04/17.
//

import SwiftUI

struct Company: Identifiable {
    let id = UUID()
    var name: String
    var status: String
    var color: Color
    
    // 追加：新しい企業を作る時に使いやすくするための初期化関数
    init(name: String, status: String, color: Color = .blue) {
        self.name = name
        self.status = status
        self.color = color
    }
}



struct ContentView: View {
    @State var companies = [
        Company(name: "サイボウズ", status: "インターン応募中", color: .orange)
    ]
    @State private var isShowingAddView = false // 追加画面を出すかどうかのフラグ

    var body: some View {
        NavigationStack {
            List {
                ForEach(companies) { company in
                    // 前回のリスト表示コード（省略）
                    VStack(alignment: .leading) {
                        Text(company.name).font(.headline)
                        Text(company.status).font(.caption).foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteCompany)
            }
            .navigationTitle("就活ステータス")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddView = true }) {
                        Image(systemName: "plus") // 右上の＋ボタン
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            // ここで追加画面を「シート」として出す
            .sheet(isPresented: $isShowingAddView) {
                AddCompanyView { newCompany in
                    companies.append(newCompany) // 新しい企業をリストに足す
                }
            }
        }
    }
    
    func deleteCompany(at offsets: IndexSet) {
        companies.remove(atOffsets: offsets)
    }
}
struct AddCompanyView: View {
    @Environment(\.dismiss) var dismiss // 画面を閉じるための変数
    @State private var name = ""
    @State private var status = "エントリー予定"
    
    var onSave: (Company) -> Void // 保存した時にContentViewにデータを渡すための仕掛け

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("企業情報")) {
                    TextField("企業名を入力", text: $name)
                    TextField("選考状況", text: $status)
                }
            }
            .navigationTitle("企業を追加")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        let newCompany = Company(name: name, status: status)
                        onSave(newCompany) // データを渡す
                        dismiss() // 画面を閉じる
                    }
                    .disabled(name.isEmpty) // 名前が空ならボタンを押せなくする
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
            }
        }
    }
}
