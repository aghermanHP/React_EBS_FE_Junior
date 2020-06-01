import React from 'react';
import axios from 'axios';
import '../styles/styles.css';
import CartComponent from './Cart';
import { type } from 'os';

export default class TableComponent extends React.Component {
  state = {
    products: [{ id: 0, name: '', category: { id: '', name: '' }, price: 0 }],
    loading: true,
    error: false,
    showProducts: true,
    showCart: false,
    // eslint-disable-next-line
    cart: Array(),
  };
  sortPriceAsc() {
    const { products } = this.state;
    this.setState({ products: products.sort((a, b) => a.price - b.price) });
  }
  sortPriceDesc() {
    const { products } = this.state;
    this.setState({ products: products.sort((a, b) => b.price - a.price) });
  }
  sortNameAsc() {
    const { products } = this.state;
    this.setState({ products: products.sort((a, b) => (a.name > b.name ? 1 : b.name > a.name ? -1 : 0)) });
  }
  sortNameDesc() {
    const { products } = this.state;
    this.setState({ products: products.sort((a, b) => (b.name > a.name ? 1 : a.name > b.name ? -1 : 0)) });
  }
  deleteFromCart(x: any) {
    let { cart } = this.state;
    let newQuantity = 0;
    if (x.quantity > 1) {
      newQuantity = x.quantity - 1;
    } else if ((x.quantity = 1)) {
      alert('product:' + x.name + 'was deleted from the cart');
      cart.forEach((item, index) => {
        if (item === x) cart.splice(index, 1);
      });
      delete cart[x];
    } else {
      alert('product: ' + x.name + " isn't in the cart");
    }
    x.quantity = newQuantity;
    cart[x] = x;
    this.setState({
      cart: cart,
    });
  }
  addToCart(x: any) {
    let { cart } = this.state;
    let ids = Array();
    cart.map((item) => {
      ids.push(item.id);
    });
    if (ids.includes(x.id)) {
      let newQuantity = x.quantity + 1;
      x.quantity = newQuantity;
    } else {
      x.quantity = 1;
      cart.push(x);
    }
    this.setState({
      cart: cart,
    });
  }
  products() {
    return axios({
      url: 'http://localhost:3001/api/products/',
      method: 'get',
    }).then((response) => {
      this.setState({
        products: response.data,
        loading: false,
      });
      return response.data;
    });
  }
  componentDidMount() {
    this.products();
  }
  render() {
    const { products, loading, error, showProducts, showCart, cart } = this.state;
    // const sorted = products.sort((a, b) => b.price - a.price);
    // console.log(sorted);
    return (
      <div>
        <header>
          <button onClick={() => this.setState({ showProducts: true, showCart: false })}>Products</button>
          <button onClick={() => this.setState({ showProducts: false, showCart: true })}>Cart</button>
        </header>
        {loading && <div>Loading...</div>}
        {error && <div>Error message</div>}
        {!loading && !error && showProducts && (
          <table>
            <thead>
              <tr>
                <th colSpan={5} style={{ textAlign: 'center' }}>
                  {' '}
                  Products{' '}
                </th>
              </tr>
              <tr style={{ backgroundColor: 'gray' }}>
                <th>ID</th>
                <th>
                  Name
                  {showProducts && <button onClick={() => this.sortNameAsc()}>&#8681;</button>}
                  {showProducts && <button onClick={() => this.sortNameDesc()}>&#8679;</button>}
                </th>
                <th>Category</th>
                <th>
                  Price
                  {showProducts && <button onClick={() => this.sortPriceAsc()}>&#8681;</button>}
                  {showProducts && <button onClick={() => this.sortPriceDesc()}>&#8679;</button>}
                </th>
                <th>Actions</th>
              </tr>
            </thead>

            <tbody>
              {products.map((product) => (
                <tr key={product.id}>
                  {<td>{product.id}</td>}
                  {<td>{product.name}</td>}
                  {<td>{product.category.id}</td>}
                  {<td>{product.price}</td>}
                  {
                    <td>
                      <button onClick={() => this.addToCart(product)}>Add To Cart</button>
                      <button onClick={() => this.deleteFromCart(product)}>Delete from Cart</button>
                      <div>
                        {' '}
                        Quantity:
                        {cart.map((item) => {
                          if (item.id == product.id) {
                            return item.quantity;
                          }
                        })}
                      </div>
                    </td>
                  }
                </tr>
              ))}
            </tbody>
          </table>
        )}
        {!loading && !error && showCart && <CartComponent cart={{ item: this.state.cart }} />}
      </div>
    );
  }
}
