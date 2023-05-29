import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/PODIO/book.dart';
import 'package:statenotifier_flux/data_sources/graphql/graphql_client.dart';
import 'package:statenotifier_flux/main.dart';

String readRepositories = """
query ExampleQuery {
  books {
    title
    author
  }
}
""";

class BooksRepository {
  final GraphQLClient graphQLClient;
  BooksRepository(this.graphQLClient);
  factory BooksRepository.fromRef(WidgetRef ref) => BooksRepository(ref.read(graphqlClientProvider));

  Future<List<Book>> fetchBooks() async {
    final QueryOptions options = QueryOptions(document: gql(readRepositories));
    final result = await graphQLClient.query(options);
    return BookResultSerializer.fromJson(result.data as Map<String, dynamic>).toPodio();
  }
}
