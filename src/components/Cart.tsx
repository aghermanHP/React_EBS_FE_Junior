import React from 'react';
import '../styles/styles.css';

interface IRecipeProps {
  cart: { item: Array<any> };
}

interface IRecipeState {}

export default class CartComponent extends React.Component<IRecipeProps, IRecipeState, never> {
  render() {
    const { cart } = this.props;
    const Aligncenter = {
      'text-align': 'center',
    };
    return (
      <div>
        <table>
          <thead>
            <tr>
              <th colSpan={5} style={{ textAlign: 'center' }}>
                {' '}
                Cart{' '}
              </th>
            </tr>
            <tr style={{ backgroundColor: 'gray' }}>
              <th>ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Price</th>
              <th>Quantity</th>
            </tr>
          </thead>
          <tbody>
            {/* {JSON.stringify(cart.item.map(car => console.log(car.id)))} */}
            {cart.item.map((car) => (
              <tr key={car.id}>
                {<td>{car.id}</td>}
                {<td>{car.name}</td>}
                {<td>{car.category.id}</td>}
                {<td>{car.price}</td>}
                {<td>{car.quantity}</td>}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }
}
