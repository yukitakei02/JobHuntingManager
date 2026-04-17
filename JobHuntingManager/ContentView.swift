//
//  ContentView.swift
//  JobHuntingManager
//
//  Created by 竹井佑騎 on 2026/04/17.
//

import SwiftUI
import SwiftData // 忘れずに追加

enum SelectionStatus: String, CaseIterable, Identifiable {
    case draft = "エントリー予定"
    case applied = "エントリー済み"
    case interviewing = "面接中"
    case offered = "内定"
    case rejected = "お見送り"
    
    var id: String { self.rawValue }
}
@Model // これだけで保存可能なオブジェクトになります
class Company: Identifiable {
    var id: UUID = UUID()
    var name: String
    var status: String
    var colorName: String // Color型は直接保存できないため、色名などの文字列で保存するのが一般的です

    init(name: String, status: String, colorName: String = "blue") {
        self.name = name
        self.status = status
        self.colorName = colorName
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // 倉庫への出し入れ担当
    @Query var companies: [Company] // 保存されているデータを自動取得
    
    @State private var isShowingAddView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(companies) { company in
                    VStack(alignment: .leading) {
                        Text(company.name).font(.headline)
                        Text(company.status).font(.caption)
                    }
                }
                .onDelete(perform: deleteCompany)
            }
            .navigationTitle("就活ステータス")
            .toolbar {
                Button(action: { isShowingAddView = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isShowingAddView) {
                AddCompanyView { newCompany in
                    modelContext.insert(newCompany) // 倉庫へ保存！
                }
            }
        }
    }
    
    func deleteCompany(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(companies[index]) // 倉庫から削除！
        }
    }
}
struct AddCompanyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    // 初期値を enum の「エントリー予定」にする
    @State private var status = SelectionStatus.draft
    
    var onSave: (Company) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("企業情報")) {
                    TextField("企業名を入力", text: $name)
                    
                    // ここが「選択肢」の部品！
                    Picker("選考状況", selection: $status) {
                        ForEach(SelectionStatus.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(.menu) // iOSらしいメニュー形式。 .navigationLink に変えてもかっこいいです。
                }
            }
            .navigationTitle("企業を追加")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        // 選択されたstatusの文字列を渡す
                        let newCompany = Company(name: name, status: status.rawValue)
                        onSave(newCompany)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
            }
        }
    }
}
