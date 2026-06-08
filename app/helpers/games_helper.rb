module GamesHelper
  # Card cover image. Per the Figma mock, every listing uses the same default
  # game image; the game name is kept as the alt text for accessibility.
  def game_cover_tag(game)
    image_tag "figma/game-default.jpg", alt: game.name, loading: "lazy", class: "game-card__img"
  end
end
