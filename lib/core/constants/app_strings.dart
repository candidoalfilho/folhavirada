// 📚 FolhaVirada - App Strings
// Strings localizadas da aplicação (PT-BR)

class AppStrings {
  // App
  static const String appName = 'FolhaVirada';
  static const String appDescription = 'Catálogo de Livros Lidos';

  // Navigation
  static const String home = 'Início';
  static const String books = 'Livros';
  static const String myBooks = 'Meus Livros';
  static const String stats = 'Estatísticas';
  static const String statistics = 'Estatísticas';
  static const String settings = 'Configurações';
  static const String addBook = 'Adicionar Livro';
  static const String appTitle = 'FolhaVirada';
  static const String welcome = 'Bem-vindo ao FolhaVirada!';
  static const String search = 'Buscar';

  // Book Status
  static const String wantToRead = 'Quero ler';
  static const String reading = 'Lendo agora';
  static const String readingNow = 'Lendo Agora';
  static const String read = 'Lidos';
  static const String readBooks = 'Lidos';

  // Book Details
  static const String title = 'Título';
  static const String author = 'Autor';
  static const String publisher = 'Editora';
  static const String publishedYear = 'Ano de publicação';
  static const String pages = 'Páginas';
  static const String genre = 'Gênero';
  static const String description = 'Descrição';
  static const String notes = 'Notas pessoais';
  static const String rating = 'Avaliação';
  static const String startDate = 'Data de início';
  static const String endDate = 'Data de término';
  static const String progress = 'Progresso';

  // Actions
  static const String add = 'Adicionar';
  static const String edit = 'Editar';
  static const String delete = 'Excluir';
  static const String save = 'Salvar';
  static const String cancel = 'Cancelar';
  static const String filter = 'Filtrar';
  static const String sort = 'Ordenar';
  static const String share = 'Compartilhar';
  static const String export = 'Exportar';
  static const String backup = 'Backup';
  static const String restore = 'Restaurar';
  static const String ok = 'OK';
  static const String yes = 'Sim';
  static const String no = 'Não';

  // Forms
  static const String required = 'Campo obrigatório';
  static const String invalidInput = 'Entrada inválida';
  static const String searchHint = 'Busque por título ou autor...';
  static const String notesHint = 'Suas anotações sobre este livro...';

  // Messages
  static const String noBooks = 'Nenhum livro encontrado';
  static const String noBooksInCategory = 'Nenhum livro nesta categoria';
  static const String bookAdded = 'Livro adicionado com sucesso!';
  static const String bookUpdated = 'Livro atualizado com sucesso!';
  static const String bookDeleted = 'Livro removido com sucesso!';
  static const String errorAddingBook = 'Erro ao adicionar livro';
  static const String errorUpdatingBook = 'Erro ao atualizar livro';
  static const String errorDeletingBook = 'Erro ao remover livro';
  static const String errorLoadingBooks = 'Erro ao carregar livros';
  static const String internetRequired = 'Conexão com internet necessária';

  // Statistics
  static const String totalBooks = 'Total de livros';
  static const String booksRead = 'Livros lidos';
  static const String currentlyReading = 'Lendo atualmente';
  static const String wantToReadCount = 'Quero ler';
  static const String pagesRead = 'Páginas lidas';
  static const String averageRating = 'Avaliação média';
  static const String readingGoal = 'Meta de leitura';
  static const String booksThisYear = 'Livros este ano';
  static const String booksThisMonth = 'Livros este mês';
  static const String favoriteGenre = 'Gênero favorito';
  static const String averageReadingTime = 'Tempo médio de leitura';
  static const String readingStreak = 'Sequência de leitura';

  // Settings
  static const String theme = 'Tema';
  static const String lightTheme = 'Claro';
  static const String darkTheme = 'Escuro';
  static const String systemTheme = 'Sistema';
  static const String language = 'Idioma';
  static const String notifications = 'Notificações';
  static const String dataManagement = 'Gerenciamento de dados';
  static const String about = 'Sobre';
  static const String version = 'Versão';
  static const String privacyPolicy = 'Política de privacidade';
  static const String termsOfService = 'Termos de serviço';

  // Ads
  static const String watchAdForReward = 'Assistir anúncio para desbloquear';
  static const String adLoadError = 'Erro ao carregar anúncio';
  static const String rewardEarned = 'Recompensa obtida!';

  // Google Books
  static const String searchOnline = 'Buscar online';
  static const String searchResults = 'Resultados da busca';
  static const String noResultsFound = 'Nenhum resultado encontrado';
  static const String selectBook = 'Selecionar livro';

  // Filters and Sorting
  static const String filterByGenre = 'Filtrar por gênero';
  static const String filterByStatus = 'Filtrar por status';
  static const String filterByRating = 'Filtrar por avaliação';
  static const String sortByTitle = 'Ordenar por título';
  static const String sortByAuthor = 'Ordenar por autor';
  static const String sortByDate = 'Ordenar por data';
  static const String sortByRating = 'Ordenar por avaliação';
  static const String ascending = 'Crescente';
  static const String descending = 'Decrescente';

  // Confirmation dialogs
  static const String confirmDelete = 'Confirmar exclusão';
  static const String confirmDeleteMessage = 'Tem certeza que deseja excluir este livro?';
  static const String confirmExport = 'Exportar dados';
  static const String confirmExportMessage = 'Deseja exportar seus dados?';

  // Error messages
  static const String genericError = 'Ocorreu um erro inesperado';
  static const String networkError = 'Erro de conexão';
  static const String timeoutError = 'Tempo limite excedido';
  static const String notFoundError = 'Não encontrado';
  static const String unauthorizedError = 'Não autorizado';

  // Empty states
  static const String emptyLibrary = 'Sua biblioteca está vazia';
  static const String emptyLibraryMessage = 'Adicione seu primeiro livro para começar!';
  static const String emptySearch = 'Nenhum resultado';
  static const String emptySearchMessage = 'Tente buscar com outros termos';
  static const String emptyStats = 'Sem estatísticas';
  static const String emptyStatsMessage = 'Adicione livros para ver suas estatísticas';

  // Reading progress
  static const String startReading = 'Começar a ler';
  static const String finishReading = 'Terminar leitura';
  static const String updateProgress = 'Atualizar progresso';
  static const String currentPage = 'Página atual';
  static const String totalPages = 'Total de páginas';
  static const String percentComplete = '% concluído';

  // Validation messages
  static const String titleRequired = 'Título é obrigatório';
  static const String authorRequired = 'Autor é obrigatório';
  static const String invalidYear = 'Ano inválido';
  static const String invalidPages = 'Número de páginas inválido';
  static const String invalidRating = 'Avaliação inválida';

  // Novas strings adicionais
  static const String addBookTitle = 'Adicionar Livro';
  static const String searchOnlineHint = 'Digite título, autor ou ISBN...';
  static const String bookAddedSuccess = 'Livro adicionado com sucesso!';
  static const String errorAddingBookMsg = 'Erro ao adicionar livro';
  static const String internetRequiredMsg = 'Conexão com internet necessária';
}
