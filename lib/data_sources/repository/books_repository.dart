import 'package:graphql/client.dart';
import 'package:statenotifier_flux/data_sources/graphql/graphql_client.dart';

String readRepositories = """
query ExampleQuery {
  books {
    title
  }
}
""";

class BooksRepository {
  final QueryOptions options = QueryOptions(
    document: gql(readRepositories),
  );

  Future<dynamic> fetchBooks() async {
    final result = await createClient().query(options);

    final book = result.data?['books'][0];
    print('hogheohgeo: ${book}');
    print('hgeaghagheoi');

    // if (result.hasException) {
    //   print('errordってます');
    //   print(result.exception.toString());
    // }
    //
    // final List<dynamic> books = result.data!['books'] as List<dynamic>;
    return 'books';
  }
}
