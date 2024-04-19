import Foundation

final class MockData {
    
    static let shared = MockData()
    
    private let user1 = LeaderBoardModel(
        id: "1",
        name: "Elijah Anderson",
        avatar: URL(string: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/179.jpg")!,
        countOfNft: 112)
    private let user2 = LeaderBoardModel(
        id: "2",
        name: "Mason Clark",
        avatar: URL(string: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/421.jpg")!,
        countOfNft: 98)
    private let user3 = LeaderBoardModel(
        id: "3",
        name: "Luna Jackson",
        avatar: URL(string: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/671.jpg")!,
        countOfNft: 72)
    private let user4 = LeaderBoardModel(
        id: "4",
        name: "Grace Martinez",
        avatar: URL(string: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/846.jpg")!,
        countOfNft: 71)
    private let user5 = LeaderBoardModel(
        id: "5",
        name: "Jasper Butler",
        avatar: URL(string: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/569.jpg")!,
        countOfNft: 51)
    
    private let info1: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ac justo dui. Curabitur pulvinar mauris quis euismod fringilla. Integer tempus massa nisl, lacinia rutrum lorem scelerisque vitae. Nunc et diam ornare, tincidunt leo ac, maximus metus. Nulla interdum feugiat augue efficitur dictum. Curabitur mollis tincidunt turpis, nec aliquam libero auctor ac. Donec."
    private let info2: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec eget."
    private let info3: String = "Lorem ipsum."
    private let info4: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin massa dui, tempor nec arcu ut, volutpat blandit tortor. Sed in ligula blandit mi maximus sollicitudin. Nulla ipsum lectus, semper porta enim ut, dapibus convallis libero. Duis finibus nisl vitae fermentum efficitur. Praesent maximus ultrices faucibus. Praesent sit amet ipsum vel eros pharetra ultricies. Pellentesque nibh odio, blandit vel sagittis eget, consequat id dolor. Mauris in urna quis ligula vestibulum lacinia ut lacinia erat. Praesent at libero mauris. Proin quam mauris, vulputate sit amet tempus eget, pellentesque non enim. Integer ac magna mattis, fermentum metus eu, bibendum velit. Sed eleifend ligula non turpis tincidunt, in lacinia orci dignissim. Pellentesque ut ullamcorper quam. Fusce."
    private let info5: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam sagittis tortor vel dapibus accumsan. Morbi tincidunt interdum mi, sed rhoncus quam ultrices id. Curabitur ligula est, iaculis quis nisi quis, fringilla varius odio. Ut id velit quis libero suscipit lobortis eget mattis mi. Etiam tortor metus, euismod sed ligula in, luctus gravida velit. Nunc non augue non elit pharetra fermentum. In hac habitasse platea dictumst. Nunc eu est pretium, pharetra quam eget, imperdiet ante. Pellentesque sodales, urna vel pharetra sodales, justo neque auctor libero, nec tincidunt mauris eros eget nibh."
    
    private let website1 = URL(string: "https://practicum.yandex.ru/qa-engineer/")!
    private let website2 = URL(string: "https://practicum.yandex.ru/web/")!
    private let website3 = URL(string: "https://practicum.yandex.ru/cpp/")!
    private let website4 = URL(string: "https://practicum.yandex.ru/qa-automation-engineer-java/")!
    private let website5 = URL(string: "https://practicum.yandex.ru/algorithms/")!
    
    private let nft1 = NftModel(
        id: "1",
        name: "April",
        avatar: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
        price: "4.5",
        rating: 5)
    private let nft2 = NftModel(
        id: "2",
        name: "Aurora",
        avatar: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Aurora/1.png")!,
        price: "1.69",
        rating: 4)
    private let nft3 = NftModel(
        id: "3",
        name: "Bimbo",
        avatar: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Bimbo/1.png")!,
        price: "6.02",
        rating: 4)
    private let nft4 = NftModel(
        id: "4",
        name: "Biscuit",
        avatar: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Biscuit/1.png")!,
        price: "5.95",
        rating: 5)
    private let nft5 = NftModel(
        id: "5",
        name: "Breena",
        avatar: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Breena/1.png")!,
        price: "7.05",
        rating: 2)
    
    var leaderboardStatistic: [LeaderBoardModel] = []
    var userCardInfo: [ProfileModel] = []
    var collectionOfNft: [NftModel] = []
    
    init() {
        setMockData()
    }
    
    func setMockData() {
        [
            (user1, info1, nft1, website1),
            (user2, info2, nft2, website2),
            (user3, info3, nft3, website3),
            (user4, info4, nft4, website4),
            (user5, info5, nft5, website5)
        ].forEach {
            leaderboardStatistic.append($0.0)
            userCardInfo.append(
                ProfileModel(id: $0.0.id,
                             name: $0.0.name,
                             avatar: $0.0.avatar,
                             description: $0.1, 
                             website: $0.3,
                             countOfNft: $0.0.countOfNft)
            )
            collectionOfNft.append($0.2)
        }
    }
}
