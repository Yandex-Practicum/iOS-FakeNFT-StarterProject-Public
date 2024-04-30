final class InteractorsAssembly {

    let likesInteractor: LikesInteraction
    let basketInteractor: BasketInteraction

    init(
        likesInteractor: LikesInteraction,
        basketInteractor: BasketInteraction
    ) {
        self.likesInteractor = likesInteractor
        self.basketInteractor = basketInteractor
    }
}
 
