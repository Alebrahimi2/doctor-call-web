# Fullstack Application

This project is a fullstack application consisting of a frontend built with React and a backend powered by Laravel. The frontend is responsible for displaying information and details, while the backend handles user authentication and data management through an API.

## Project Structure

```
fullstack-app
├── frontend
│   ├── src
│   │   ├── components
│   │   ├── pages
│   │   └── App.tsx
│   ├── package.json
│   └── README.md
├── backend
│   ├── app
│   │   ├── Http
│   │   │   └── Controllers
│   │   └── Models
│   ├── routes
│   │   └── api.php
│   ├── composer.json
│   └── README.md
└── README.md
```

## Frontend

The frontend is located in the `frontend` directory. It is built using React and includes the following:

- **Components**: Reusable React components are stored in `frontend/src/components`.
- **Pages**: Different views of the application are organized in `frontend/src/pages`.
- **Main Application**: The main component is defined in `frontend/src/App.tsx`.

To set up the frontend, navigate to the `frontend` directory and run:

```bash
npm install
npm start
```

## Backend

The backend is located in the `backend` directory and is built using Laravel. It includes:

- **Controllers**: Handles requests related to user login and other functionalities in `backend/app/Http/Controllers`.
- **Models**: Eloquent models for database interactions are found in `backend/app/Models`.
- **API Routes**: Defined in `backend/routes/api.php` for user authentication and other endpoints.

To set up the backend, navigate to the `backend` directory and run:

```bash
composer install
php artisan migrate
php artisan serve
```

## Connecting Frontend and Backend

The frontend communicates with the backend through an API. Ensure that the backend server is running before starting the frontend application. Adjust the API endpoints in the frontend code as necessary to match the backend routes.

## License

This project is licensed under the MIT License.