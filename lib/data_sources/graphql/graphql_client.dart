import 'package:graphql/client.dart';

GraphQLClient createClient() {
  final httpLink = HttpLink('http://192.168.10.4:4000/graphql');

  final client = GraphQLClient(
    /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(),
    link: httpLink,
  );

  return client;
}
