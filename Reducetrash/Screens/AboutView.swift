import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
        
            
            Image("appIcon")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.green, lineWidth: 5))
                .shadow(radius: 5)
            
            Text("App Name")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.green)
            
            Text("Version 1.0.0")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Description")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.green)
                .padding(.top, 20)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent auctor augue a urna ullamcorper, id eleifend lectus interdum. Etiam id metus dui. Morbi eu libero velit. Sed tristique, felis nec semper bibendum, mauris mauris bibendum nulla, vel semper tellus tellus vitae elit. Phasellus pharetra, dolor vel consequat blandit, sapien massa laoreet sapien, sit amet malesuada felis eros vel enim. Vestibulum et ipsum non nisl efficitur laoreet. Nulla facilisi. ")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 30)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color.white)
        .navigationBarTitle("About")
    }
}
