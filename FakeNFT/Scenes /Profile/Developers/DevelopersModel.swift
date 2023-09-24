//
//  DevelopersModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 24.09.2023.
//

import Foundation

final class DevelopersModel {
    static let shared = DevelopersModel()
    private  let developers: [Developers] = [
          Developers(
          name: "Artem",
          image: "https://im.wampi.ru/2023/09/22/photo_2023-09-22-21.36.47.jpg",
          telegram: "@t4sher",
          email: "artem785@mail.ru",
          description: "Реализация эпика Каталог."),
          Developers(
              name: "Литвинов Антон",
              image: "https://ic.wampi.ru/2023/09/22/photo_2023-09-22-21.33.15.jpg",
              telegram: "@udachi_tomo",
              email: "fragnet1ck@gmail.com",
              description: "Реализация эпика Корзина. "),
          Developers(
              name: "Полунин Игорь",
              image: "https://im.wampi.ru/2023/09/23/IMG_0580.jpg",
              telegram: "@Garrisson9",
              email: "garry.818@yandex.ru",
              description: "Реализация эпика профиль пользователя:\n - экран Мои НФТ\n - экран Избранные НФТ\n - экран О разработчике\n - экран редактирования профиля"
          )]

     func getAllDevs() -> [Developers] {
        return developers
    }
}
