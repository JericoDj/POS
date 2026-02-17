import '../models/product_model.dart';

class MockProductData {
  static final List<Product> products = [
    Product(
      id: '1',
      name: 'Latte',
      categoryId: 'coffee_id',
      categoryName: 'Coffee',
      price: 4.50,
      stock: 100,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB54cQc2xWbL8kgums124aAIxX6L6aXvezO6vtQYh2waJKtCuEvXYVPa9gApMxN7CaQLBsVCEoBoU1mrpfK3sQHHCsyXvWBcxE7urt-_Rkdh9cCk_axjZOQQ-Vy80Z34J3onQr9nJNWs3ChkSbPWi0a8dIq0H-GWIccbO1t5W4-1PvUejG5k83L7oT6nyMzZ2RskyXq7LxJk86__g5L7fWwvIJx_RfqLZlJWMlwd7YKTyVlzzB9TnNj7eyTDVxyYQdbWPuB-y4ikhF0',
      details: '12 oz',
    ),
    Product(
      id: '2',
      name: 'Croissant',
      categoryId: 'pastries_id',
      categoryName: 'Pastries',
      price: 3.00,
      stock: 50,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDbV-kJAd_e4lKSiE8k1sLh6wNE2dcNZHW1J65o5oqyxbgUfRNTAA4dmoH_6EUsT_v0vqn3VLfWmbduwE9QdkprkOMkm2UvGGlcv0jl5anM03zh0_tz-Lgoq3cz2dWKMeXZ1lS6Iz3OaFjrZtEBUoAILQgEYPqdL0ecvOf5MpU8cwhry2fMAK0uVtggcfLqGUdPNC6y2JrkKYNLCOaWwrK1LBJvOsWW8xC-MOoELbZ1jA_pHf6djxma43dB6yNiBWQIds0RAaWUSD_D',
      details: 'Butter',
    ),
    Product(
      id: '3',
      name: 'Avo Toast',
      categoryId: 'food_id',
      categoryName: 'Food',
      price: 8.50,
      stock: 30,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB3t6HO50eZ5DknwfJ07_i-CTPtixU1lbz3gvfd7a6wmLCUGjI9PsdxIzELL_cx5M6snDgSY0ooILafUW6dN4sB6F2fwS7dvgWo0ob3V5zGtg44N1HzOZNVLwZpd2yJ_IEQi5-7FfZfuRC9nOvz_S-Bms-oaxfxeNredBlNQd4uj1KjLmbVfnPLFnx4nAhR09FEQ86SLsfZM4fVW09vN6oh4Jj-_5DVtDk-tOwKLpoDxh6fvu27d9SnBZghjypAg8wILTOFZ8qh66iL',
      details: 'Sourdough',
    ),
    Product(
      id: '4',
      name: 'Cappuccino',
      categoryId: 'coffee_id',
      categoryName: 'Coffee',
      price: 4.00,
      stock: 80,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJVxmscgRdaxnF6ExRbhoS53RMyGUuKkwIbg79FJ92rfhP1ODpMyfzo7MxWp2P8sX6t4Z5i2U1mo_BG7Txpuhq5wPg5gnzInMpJKCZgV3KLuCzVGgC7MLSUg9OLcs7b6FumR5JUNRAMxII585A9hWjrlsr_zU4cDZTTJFxWpYRN4PVfZ6utAg5pTJT5ha1hjBG8bKSsiqP5jV3KqoUgcOPEwFjl11u0njjHwDCKTow3dDqHmIhJwNEQPn5BTR7vsKXpRFkWb2W4Qcr',
      details: '8 oz',
    ),
    Product(
      id: '5',
      name: 'Bagel',
      categoryId: 'pastries_id',
      categoryName: 'Pastries',
      price: 2.50,
      stock: 40,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDgds_uWxxJsPQ-f3yQdVLCtd8hxogqbUM7F25S5IUWUL4ZLsVKOPd6856D_ortsbLlspSZs6vKFF9gkDyYdKEyxR2yZvgrqGSwNpkrR42HOxND-Dd-Wn-A08pCtXn4fqOwZA5LBS2O9B0F3HUur3735sNrEqjwTuw_0Yw_QSGFIHapmLkDoI3ylKAVuxbDeiMDCWNmYgmNqsOESuWRUJXsc4PGCvA5qvE7TFH61EZOGT__yNU55R4kWTnw_ANQR5zjJYW_uBIAmgyR',
      details: 'Plain',
    ),
    Product(
      id: '6',
      name: 'Iced Tea',
      categoryId: 'drinks_id',
      categoryName: 'Drinks',
      price: 3.50,
      stock: 60,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuALDTfdD88u7Oq6zIOMD8-BzS1exSdVVlR7rP_AgsYRktH_TOzNu6iJy0EzAHsXgumv3FHJ4v3U9or7u8Zklux3TVtlsduLOblfEUAe2qT4oOdmHhFjCDd7y60EYYFUYxG0JjQlZoTBp1JerC8tjrlg2H2enwh8JaCVPFfzGDgw-OOaQ39XxNEn-zILBCl2Sjx1dXt3aBwpoP_nusfeUDE6acOxqwa1wuS6YyzbIvOFBoSrCtxABU_a014zWW9vn3-cvDfmWvaJP0gQ',
      details: 'Lemon',
    ),
    Product(
      id: '7',
      name: 'Muffin',
      categoryId: 'pastries_id',
      categoryName: 'Pastries',
      price: 3.25,
      stock: 25,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDoBjl7ewK7HZ0MXCicfeJWe0ThksxPDCa1O1piM210IYgvSd3PNEh5M_so5676c7UZ3w-IHUTlnSftCdLxstmXbQtbNNp0NDW1NC4eT_IEAurviOHo4BpCbq7P6uTX7uODagWlXSwRK1m8bzuZd5wtfWg72MorN8uqlTNV_ZyaNFcwV06JPWGaBPnCIi4WYrRnNct55iM0LRn9ebveUlCGOQZRlhYgO5UeOFtdAx-kXY8nBn6R4zn54XjYEvXrc_P6k9_m3rLKYbEx',
      details: 'Blueberry',
    ),
    Product(
      id: '8',
      name: 'Espresso',
      categoryId: 'coffee_id',
      categoryName: 'Coffee',
      price: 2.75,
      stock: 100,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD3RYR95IF8QGFwgV6GZVgKZCJLAIHnXbGcpHRaVt_PZAGvIGeivO-Ly4jbWcgSJFFtCOR_5oniDenB31X1p7guAqxynzKdOvDifSy0ZZ2HbKcCQmR8RTrpA-1cWD4Ro7MuefNmiLDI3igVqwWsFIYcKRRP9flxZKPrd-gBuA4t89quaKtiaO2J0iKj9niPDLLKEjZHR0QJvUEuUjlHkj_-QgZ85xcZC4Un5VjhAyvPot522v0THWnwKDntF8dSJRLw6ljzyo8ebaLS',
      details: 'Double',
    ),
  ];
}
