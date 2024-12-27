import { application } from "./application"
import DropdownController from "./dropdown_controller"
import AlbumController from "./album_controller"
import AlbumSidebarController from "./album_sidebar_controller"
import BottomPlayerController from "./bottom_player_controller"
import FiltersController from "./filters_controller"
import PaginationController from "./pagination_controller"

application.register("dropdown", DropdownController)
application.register("album", AlbumController)
application.register("album-sidebar", AlbumSidebarController)
application.register("bottom-player", BottomPlayerController)
application.register("filters", FiltersController)
application.register("pagination", PaginationController) 