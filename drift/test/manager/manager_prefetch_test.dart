// ignore_for_file: unused_local_variable

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:test/test.dart';

import '../generated/todos.dart';
import '../test_utils/test_utils.dart';

void main() {
  late TodoDb db;
  late List<StoreData> stores;
  late List<DepartmentData> departments;
  late List<ProductData> products;
  late List<int> listings;
  final categoryData = [
    (description: "School", priority: Value(CategoryPriority.high)),
    (description: "Work", priority: Value(CategoryPriority.low)),
  ];
  late int schoolCategoryId;
  late int workCategoryId;
  late List<
      ({
        Value<RowId> category,
        String content,
        Value<TodoStatus> status,
        Value<DateTime> targetDate,
        Value<String> title
      })> todoData;

  test("manager - with references tests - foreign key", () async {
    final storeWithListings =
        db.managers.store.withReferences((o) => o(listings: true));
  });

  setUp(() async {
    db = TodoDb(testInMemoryDatabase());
    stores = [
      await db.managers.store.createReturning((o) => o(name: Value("Walmart"))),
      await db.managers.store.createReturning((o) => o(name: Value("Target"))),
      await db.managers.store.createReturning((o) => o(name: Value("Costco")))
    ];
    departments = [
      await db.managers.department
          .createReturning((o) => o(name: Value("Electronics"))),
      await db.managers.department
          .createReturning((o) => o(name: Value("Grocery"))),
      await db.managers.department
          .createReturning((o) => o(name: Value("Clothing")))
    ];
    products = [
      // Electronics
      await db.managers.product.createReturning(
          (o) => o(name: Value("TV"), department: Value(departments[0].id))),
      await db.managers.product.createReturning((o) =>
          o(name: Value("Cell Phone"), department: Value(departments[0].id))),
      await db.managers.product.createReturning((o) =>
          o(name: Value("Charger"), department: Value(departments[0].id))),
      // Grocery
      await db.managers.product.createReturning((o) =>
          o(name: Value("Cereal"), department: Value(departments[1].id))),
      await db.managers.product.createReturning(
          (o) => o(name: Value("Meat"), department: Value(departments[1].id))),
      // Clothing
      await db.managers.product.createReturning(
          (o) => o(name: Value("Shirt"), department: Value(departments[2].id))),
      await db.managers.product.createReturning(
          (o) => o(name: Value("Pants"), department: Value(departments[2].id))),
      await db.managers.product.createReturning(
          (o) => o(name: Value("Socks"), department: Value(departments[2].id))),
      await db.managers.product.createReturning(
          (o) => o(name: Value("Cap"), department: Value(departments[2].id)))
    ];
    listings = [
      // Walmart - Electronics
      await db.managers.listing.create((o) => o(
          product: Value(products[0].id),
          store: Value(stores[0].id),
          price: Value(100.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[1].id),
          store: Value(stores[0].id),
          price: Value(200.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[2].id),
          store: Value(stores[0].id),
          price: Value(10.0))),

      // Walmart - Grocery
      await db.managers.listing.create((o) => o(
          product: Value(products[3].id),
          store: Value(stores[0].id),
          price: Value(5.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[4].id),
          store: Value(stores[0].id),
          price: Value(15.0))),

      // Walmart - Clothing
      await db.managers.listing.create((o) => o(
          product: Value(products[5].id),
          store: Value(stores[0].id),
          price: Value(20.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[6].id),
          store: Value(stores[0].id),
          price: Value(30.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[7].id),
          store: Value(stores[0].id),
          price: Value(5.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[8].id),
          store: Value(stores[0].id),
          price: Value(10.0))),

      // Target - Electronics

      // Target does not have any TVs
      // But is otherwise cheaper on electronics
      // await db.managers.listing.create((o) => o(
      //     product: Value(products[0].id),
      //     store: Value(stores[0].id),
      //     price: Value(100.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[1].id),
          store: Value(stores[1].id),
          price: Value(150.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[2].id),
          store: Value(stores[1].id),
          price: Value(15.0))),

      // Target - Grocery

      // More expensive groceries
      await db.managers.listing.create((o) => o(
          product: Value(products[3].id),
          store: Value(stores[1].id),
          price: Value(10.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[4].id),
          store: Value(stores[1].id),
          price: Value(20.0))),

      // Target - Clothing

      // Does not have any shirts or pants
      // await db.managers.listing.create((o) => o(
      //     product: Value(products[5].id),
      //     store: Value(stores[1].id),
      //     price: Value(20.0))),
      // await db.managers.listing.create((o) => o(
      //     product: Value(products[6].id),
      //     store: Value(stores[1].id),
      //     price: Value(30.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[7].id),
          store: Value(stores[1].id),
          price: Value(5.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[8].id),
          store: Value(stores[1].id),
          price: Value(10.0))),

      // Costco - Electronics
      // Much cheaper electronics
      await db.managers.listing.create((o) => o(
          product: Value(products[0].id),
          store: Value(stores[2].id),
          price: Value(50.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[1].id),
          store: Value(stores[2].id),
          price: Value(100.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[2].id),
          store: Value(stores[2].id),
          price: Value(2.50))),

      // Costco - Grocery

      // More expensive groceries
      await db.managers.listing.create((o) => o(
          product: Value(products[3].id),
          store: Value(stores[2].id),
          price: Value(20.0))),
      await db.managers.listing.create((o) => o(
          product: Value(products[4].id),
          store: Value(stores[2].id),
          price: Value(900.0))),
    ];
    schoolCategoryId = await db.managers.categories.create((o) => o(
        priority: categoryData[0].priority,
        description: categoryData[0].description));
    workCategoryId = await db.managers.categories.create((o) => o(
        priority: categoryData[1].priority,
        description: categoryData[1].description));

    todoData = [
      // School
      (
        content: "Get that math homework done",
        title: Value("Math Homework"),
        category: Value(RowId(schoolCategoryId)),
        status: Value(TodoStatus.open),
        targetDate: Value(DateTime.now().add(Duration(days: 1, seconds: 10)))
      ),
      (
        content: "Finish that report",
        title: Value("Report"),
        category: Value(RowId(schoolCategoryId)),
        status: Value(TodoStatus.workInProgress),
        targetDate: Value(DateTime.now().add(Duration(days: 2, seconds: 10)))
      ),
      (
        content: "Get that english homework done",
        title: Value("English Homework"),
        category: Value(RowId(schoolCategoryId)),
        status: Value(TodoStatus.open),
        targetDate: Value(DateTime.now().add(Duration(days: 1, seconds: 15)))
      ),
      (
        content: "Finish that Book report",
        title: Value("Book Report"),
        category: Value(RowId(schoolCategoryId)),
        status: Value(TodoStatus.done),
        targetDate:
            Value(DateTime.now().subtract(Duration(days: 2, seconds: 15)))
      ),
      // Work
      (
        content: "File those reports",
        title: Value("File Reports"),
        category: Value(RowId(workCategoryId)),
        status: Value(TodoStatus.open),
        targetDate: Value(DateTime.now().add(Duration(days: 1, seconds: 20)))
      ),
      (
        content: "Clean the office",
        title: Value("Clean Office"),
        category: Value(RowId(workCategoryId)),
        status: Value(TodoStatus.workInProgress),
        targetDate: Value(DateTime.now().add(Duration(days: 2, seconds: 20)))
      ),
      (
        content: "Nail that presentation",
        title: Value("Presentation"),
        category: Value(RowId(workCategoryId)),
        status: Value(TodoStatus.open),
        targetDate: Value(DateTime.now().add(Duration(days: 1, seconds: 25)))
      ),
      (
        content: "Take a break",
        title: Value("Break"),
        category: Value(RowId(workCategoryId)),
        status: Value(TodoStatus.done),
        targetDate:
            Value(DateTime.now().subtract(Duration(days: 2, seconds: 25)))
      ),
      // Items with no category
      (
        content: "Get Whiteboard",
        title: Value("Whiteboard"),
        status: Value(TodoStatus.open),
        targetDate: Value(DateTime.now().add(Duration(days: 1, seconds: 50))),
        category: Value.absent(),
      ),
      (
        category: Value.absent(),
        content: "Drink Water",
        title: Value("Water"),
        status: Value(TodoStatus.workInProgress),
        targetDate: Value(DateTime.now().add(Duration(days: 2, seconds: 50)))
      ),
    ];
    for (var i in todoData) {
      await db.managers.todosTable.create((o) => o(
          content: i.content,
          title: i.title,
          category: i.category,
          status: i.status,
          targetDate: i.targetDate));
    }
  });

  tearDown(() => db.close());

  test('manager - with references tests', () async {
    // Get reverse references
    final storeWithListings =
        db.managers.store.withReferences((o) => o(listings: true));
    for (final (store, refs) in await storeWithListings.get()) {
      expect(refs.listings.prefetchedData, isNotEmpty);
    }
    final storeWithoutListings =
        db.managers.store.withReferences((o) => o(listings: false));
    for (final (store, refs) in await storeWithoutListings.get()) {
      expect(refs.listings.prefetchedData, isNull);
    }
    // Get reverse references with filters
    final filteredStoreWithListings = db.managers.store
        .filter((f) => f.id(1))
        .withReferences((o) => o(listings: true));
    expect(await filteredStoreWithListings.get(), hasLength(1));

    // Forwards references
    final listingWithStore =
        db.managers.listing.withReferences((o) => o(store: true));
    for (final (listing, refs) in await listingWithStore.get()) {
      expect(refs.store!.prefetchedData, hasLength(1));
    }
    final listingWithoutStore =
        db.managers.listing.withReferences((o) => o(store: false));
    for (final (listing, refs) in await listingWithoutStore.get()) {
      expect(refs.store?.prefetchedData, isNull);
    }
    // Forwards references with filters
    final filteredListingWithStore = db.managers.listing
        .filter((f) => f.id(1))
        .withReferences((o) => o(store: true));
    expect(await filteredListingWithStore.get(), hasLength(1));

    // When filters have joins and we select a referenced field with a join, they should be combined
    final listingWithStoreAndProduct = db.managers.listing
        .filter((f) => f.store.name("Walmart"))
        .withReferences((o) => o(store: true));
    final stateWithJoins = listingWithStoreAndProduct.$state.prefetchHooks
        .withJoins(listingWithStoreAndProduct.$state);
    expect(stateWithJoins.joinBuilders, hasLength(1));
    for (final (listing, refs) in await listingWithStoreAndProduct.get()) {
      expect(refs.store?.prefetchedData, isNotNull);
    }

    final prductWuthListings = await db.managers.product
        .withReferences((o) => o(listings: true))
        .get();
    for (final (product, refs) in prductWuthListings) {
      expect(refs.listings.prefetchedData, isNotEmpty);
    }

    final prductWuthListingsStream = db.managers.product
        .withReferences((o) => o(listings: true))
        .watch()
        .map((event) => event.map((e) => e.$2.listings));
    expect(prductWuthListingsStream, emitsInOrder([isNotEmpty]));
  });
}
