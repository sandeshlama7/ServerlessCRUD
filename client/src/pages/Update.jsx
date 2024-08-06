import React, { useState, useEffect } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import axios from "../axiosInstance";

const Update = () => {
  const [book, setBook] = useState([]);
  const [error, setError] = useState(false);

  const location = useLocation();
  const navigate = useNavigate();
  const bookId = location.pathname.split("/")[2];

  const fetchBook = async () => {
    try {
      const res = await axios.get(`/books/${bookId}`);
      console.log(res);
      setBook(res.data); // Assuming res.data[0] contains the book you want to edit
    } catch (err) {
      console.log(err);
      setError(true);
    }
  };

  useEffect(() => {
    fetchBook();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    const indexMap = {
      title: 1,
      desc: 2,
      price: 3,
      cover: 4,
    };
    setBook((prev) => {
      const newBook = [...prev];
      newBook[indexMap[name]] = value;
      return newBook;
    });
  };

  const handleClick = async (e) => {
    e.preventDefault();

    try {
      const updatedBook = {
        id: book[0],
        title: book[1],
        desc: book[2],
        price: book[3],
        cover: book[4],
      };
      await axios.put(`/books/${bookId}`, updatedBook);
      navigate("/");
    } catch (err) {
      console.log(err);
      setError(true);
    }
  };

  return (
    <div className="form">
      <h1>Update the Book</h1>
      <input
        type="text"
        placeholder="Book title"
        name="title"
        value={book[1] || ""}
        onChange={handleChange}
      />
      <textarea
        rows={5}
        type="text"
        placeholder="Book desc"
        name="desc"
        value={book[2] || ""}
        onChange={handleChange}
      />
      <input
        type="number"
        placeholder="Book price"
        name="price"
        value={book[3] || ""}
        onChange={handleChange}
      />
      <input
        type="text"
        placeholder="Book cover"
        name="cover"
        value={book[4] || ""}
        onChange={handleChange}
      />
      <button onClick={handleClick}>Update</button>
      {error && <span>Something went wrong!</span>}
      <Link to="/">See all books</Link>
    </div>
  );
};

export default Update;
