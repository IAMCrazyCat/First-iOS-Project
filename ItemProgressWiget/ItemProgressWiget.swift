//
//  ItemProgressWiget.swift
//  ItemProgressWiget
//
//  Created by Christian Liu on 23/3/21.
//

import WidgetKit
import SwiftUI
import Intents

struct User {
    let avatar: UIImage
    let themeColor: UIColor
    let overAllProgress: Double
}

struct UserLoader {
    static func getUser() -> User {
        
        guard
            let overAllProgress = UserDefaults(suiteName: AppGroup.identifier.rawValue)?.double(forKey: "OverAllProgress"),
            let themeColor = UserDefaults(suiteName: AppGroup.identifier.rawValue)?.color(forKey: "ThemeColor"),
            let avatar = UserDefaults(suiteName: AppGroup.identifier.rawValue)?.image(forKey: "AvatarImage")
        else {
            return UserLoader.getDummyUser()
        }
        return User(avatar: avatar, themeColor: themeColor, overAllProgress: overAllProgress)
    }
    
    static func getDummyUser() -> User {
        return User(avatar: UIImage(), themeColor: .red, overAllProgress: 0.8)
    }
}

struct OverAllProgressProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> OverAllProgressEntry {
        return OverAllProgressEntry(date: Date(), user: UserLoader.getDummyUser())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (OverAllProgressEntry) -> Void) {
        
        let entry = OverAllProgressEntry(date: Date(), user: UserLoader.getUser())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<OverAllProgressEntry>) -> Void) {
        var entries: [OverAllProgressEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = OverAllProgressEntry(date: entryDate, user: UserLoader.getUser())
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    typealias Entry = OverAllProgressEntry

}

struct OverAllProgressEntry: TimelineEntry {
    let date: Date
    let user: User
   
}



struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.white)
        }
    }
}

struct ItemProgressWigetEntryView : View {
    var entry: OverAllProgressEntry
    

    var body: some View {

        ZStack {
            Image(uiImage: entry.user.avatar)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 85, height: 85, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(Circle())
            
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(Color(entry.user.themeColor))
                .padding(.all, 25.0)
        
            Circle()
                .trim(from: 0.0, to: CGFloat(min(entry.user.overAllProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(entry.user.themeColor))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeOut)
                .padding(.all, 25.0)
            
            
            
            VStack{
                
                Text(String(format: "%.0f %%", min(entry.user.overAllProgress, 1.0)*100.0))
                    .bold()
                    .font(.system(size: 12))
                    .background(Color.clear)
                    .position(x: 140, y: 152)
            }
           


            
        }
        

        
        
        
        //Text(entry.date, style: .time)
    }
}

@main
struct ItemProgressWiget: Widget {
    let kind: String = "ItemProgressWiget"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: OverAllProgressProvider()) { entry in
            ItemProgressWigetEntryView(entry: entry)
                .background(Color(UIColor(named: "WidgetBackground") ?? UIColor.white))
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("综合进度")
        .description("显示你的头像和所有项目的综合进度")
    }
}

struct ItemProgressWiget_Previews: PreviewProvider {

    static var previews: some View {
        ItemProgressWigetEntryView(entry: OverAllProgressEntry(date: Date(), user: UserLoader.getDummyUser()))
    }
}
