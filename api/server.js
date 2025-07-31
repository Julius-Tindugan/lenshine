const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const moment = require('moment');

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Database configuration
const dbConfig = {
  host: 'mainline.proxy.rlwy.net',
  user: 'root',
  password: 'vrtYFNvqJZwcvZKPHHaLosYHAwgryAFf',
  database: 'railway',
  port: 16440, 
  connectionLimit: 100,
};

const pool = mysql.createPool(dbConfig);

// Validation middleware
const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

const validatePhone = (phone) => {
  const phoneRegex = /^[\d\s\-\+\(\)]+$/;
  return phoneRegex.test(phone) && phone.length >= 10;
};

const validatePassword = (password) => {
  return password && password.length >= 6;
};

const validateName = (name) => {
  return name && name.trim().length >= 2 && /^[a-zA-Z\s]+$/.test(name.trim());
};

const validateDate = (date) => {
  if (/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    return moment(date, 'YYYY-MM-DD', true).isValid();
  } else {
    const dateParts = date.split('/');
    if (dateParts.length === 3) {
      const month = dateParts[0].padStart(2, '0');
      const day = dateParts[1].padStart(2, '0');
      const year = dateParts[2];
      const formattedDate = `${year}-${month}-${day}`;
      return moment(formattedDate, 'YYYY-MM-DD', true).isValid();
    }
  }
  return false;
};

const validateTime = (time) => {
  const timeRegex = /^(1[0-2]|0?[1-9]):[0-5][0-9]\s?(am|pm)$/i;
  return timeRegex.test(time);
};

const validateAmount = (amount) => {
  return !isNaN(amount) && parseFloat(amount) > 0;
};

const validateId = (id) => {
  return !isNaN(id) && parseInt(id) > 0;
};

// Helper to get a connection from the pool
async function getConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('Database connection established');
    return connection;
  } catch (error) {
    console.error('Database connection error:', error);
    throw error;
  }
}

// --- User Registration (ENHANCED VALIDATION) ---
app.post('/register', async (req, res) => {
  const { first_name, last_name, email, phone, password } = req.body;
  
  console.log('Registration request received:', { first_name, last_name, email, phone });

  // Comprehensive validation
  const errors = [];
  
  if (!first_name || !validateName(first_name)) {
    errors.push('First name must be at least 2 characters and contain only letters');
  }
  
  if (!last_name || !validateName(last_name)) {
    errors.push('Last name must be at least 2 characters and contain only letters');
  }
  
  if (!email || !validateEmail(email)) {
    errors.push('Please provide a valid email address');
  }
  
  if (!phone || !validatePhone(phone)) {
    errors.push('Please provide a valid phone number (minimum 10 digits)');
  }
  
  if (!validatePassword(password)) {
    errors.push('Password must be at least 6 characters long');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Check if email already exists
    const [existingUsers] = await conn.execute('SELECT user_id FROM users WHERE email = ?', [email]);
    if (existingUsers.length > 0) {
      return res.status(409).json({ 
        success: false, 
        error: 'Email already exists',
        details: ['This email address is already registered']
      });
    }

    // Hash password and create user
    const hash = await bcrypt.hash(password, 10);
    const [result] = await conn.execute(
      'INSERT INTO users (first_name, last_name, email, phone, password_hash) VALUES (?, ?, ?, ?, ?)',
      [first_name.trim(), last_name.trim(), email.toLowerCase(), phone, hash]
    );
    
    console.log('User registered successfully:', { user_id: result.insertId, email });
    
    return res.status(201).json({ 
      success: true,
      message: 'User registered successfully',
      user_id: result.insertId
    });
  } catch (err) {
    console.error('Registration Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Database error during registration',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// --- User Login (ENHANCED VALIDATION) ---
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
  
  console.log('Login request received:', { email });

  // Validation
  const errors = [];
  
  if (!email || !validateEmail(email)) {
    errors.push('Please provide a valid email address');
  }
  
  if (!password) {
    errors.push('Password is required');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
  }

    let conn;
    try {
        conn = await getConnection();
    const [users] = await conn.execute('SELECT * FROM users WHERE email = ?', [email.toLowerCase()]);
    
    if (users.length === 0) {
      return res.status(401).json({ 
        success: false, 
        error: 'Invalid credentials',
        details: ['Email or password is incorrect']
      });
    }
    
    const user = users[0];
        const match = await bcrypt.compare(password, user.password_hash);
    
        if (!match) {
      return res.status(401).json({ 
        success: false, 
        error: 'Invalid credentials',
        details: ['Email or password is incorrect']
      });
    }
    
    console.log('User logged in successfully:', { user_id: user.user_id, email });
    
        return res.json({
            success: true,
      message: 'Login successful',
            user: {
                user_id: user.user_id,
                first_name: user.first_name,
                last_name: user.last_name,
                email: user.email,
                phone: user.phone,
            },
        });
    } catch (err) {
        console.error('Login Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Server error during login',
      details: [err.message]
    });
    } finally {
        if (conn) conn.release();
    }
});

// --- Get Packages (ENHANCED VALIDATION) ---
app.get('/packages', async (req, res) => {
    let conn;
    try {
        conn = await getConnection();
        const [packages, inclusions, freeItems] = await Promise.all([
            conn.execute('SELECT * FROM packages'),
            conn.execute('SELECT * FROM package_inclusions'),
            conn.execute('SELECT * FROM package_free_items')
        ]);

        if (!packages[0] || packages[0].length === 0) {
      return res.json({ 
        success: true, 
        packages: [],
        message: 'No packages found'
      });
        }

        // Map inclusions and free items to their respective packages
        const packageMap = new Map();
        packages[0].forEach(p => {
            packageMap.set(p.package_id, {
                ...p,
                inclusions: [],
                freeItems: [],
            });
        });

        inclusions[0].forEach(i => {
            if (packageMap.has(i.package_id)) {
                packageMap.get(i.package_id).inclusions.push(i.inclusion_text);
            }
        });

        freeItems[0].forEach(f => {
            if (packageMap.has(f.package_id)) {
                packageMap.get(f.package_id).freeItems.push(f.free_item_text);
            }
        });

    const packageList = Array.from(packageMap.values());
    console.log(`Fetched ${packageList.length} packages successfully`);

    res.json({ 
      success: true, 
      packages: packageList,
      message: `${packageList.length} packages found`
    });

    } catch (err) {
        console.error('Get Packages Error:', err.message);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to fetch packages',
      details: [err.message]
    });
    } finally {
        if (conn) conn.release();
    }
});

// --- Get Add-ons (ENHANCED VALIDATION) ---
app.get('/addons', async (req, res) => {
    let conn;
    try {
        conn = await getConnection();
    const [addons] = await conn.execute('SELECT addon_id, addon_name, addon_price FROM addons ORDER BY addon_id');
    console.log(`Fetched ${addons.length} add-ons successfully`);
    res.json({ 
      success: true, 
      addons,
      message: `${addons.length} add-ons found`
    });
    } catch (err) {
        console.error('Get Addons Error:', err.message);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to fetch addons',
      details: [err.message]
    });
    } finally {
        if (conn) conn.release();
    }
});

// --- Bookings (ENHANCED VALIDATION) ---
app.post('/book', async (req, res) => {
  const { user_id, package_id, booking_label, booking_date, booking_time, backdrop, addon_ids } = req.body;

  console.log('Booking request received:', {
    user_id, package_id, booking_label, booking_date, booking_time, backdrop, addon_ids
  });

  // Comprehensive validation
  const errors = [];
  
  if (!user_id || !validateId(user_id)) {
    errors.push('Valid user_id is required');
  }
  
  if (!package_id || !validateId(package_id)) {
    errors.push('Valid package_id is required');
  }
  
  if (!booking_label || booking_label.trim().length < 2) {
    errors.push('Booking label must be at least 2 characters');
  }
  
  if (!booking_date || !validateDate(booking_date)) {
    errors.push('Valid booking date is required (MM/DD/YYYY or YYYY-MM-DD format)');
  }
  
  if (!booking_time || !validateTime(booking_time)) {
    errors.push('Valid booking time is required (e.g., 10:00 am, 2:00 pm)');
  }
  
  if (backdrop && backdrop.trim().length < 2) {
    errors.push('Backdrop must be at least 2 characters if provided');
  }
  
  if (addon_ids && !Array.isArray(addon_ids)) {
    errors.push('Add-on IDs must be an array');
  }
  
  if (addon_ids && addon_ids.some(id => !validateId(id))) {
    errors.push('All add-on IDs must be valid positive integers');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
  }

  // FIXED: Handle date format conversion properly
  let formattedDate;
  try {
    // Explicitly parse the incoming 'MM/DD/YYYY' format from the Flutter app
    if (moment(booking_date, 'MM/DD/YYYY', true).isValid()) {
      formattedDate = moment(booking_date, 'MM/DD/YYYY').format('YYYY-MM-DD');
    } else if (moment(booking_date, 'YYYY-MM-DD', true).isValid()) {
      // Also handle cases where the date might already be in the correct format
      formattedDate = booking_date;
    } else {
      throw new Error('Invalid date format. Expected MM/DD/YYYY.');
    }
  } catch (error) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid booking_date format',
      details: [error.message]
    });
  }

  let conn;
  try {
    conn = await getConnection();
    await conn.beginTransaction(); 
    // Validate user exists
    const [users] = await conn.execute('SELECT user_id FROM users WHERE user_id = ?', [user_id]);
    if (users.length === 0) {
      await conn.rollback();
      return res.status(404).json({ 
        success: false, 
        error: 'User not found',
        details: ['The specified user does not exist']
      });
    }

    // Validate package exists and get price
    const [packages] = await conn.execute('SELECT price FROM packages WHERE package_id = ?', [package_id]);
    if (packages.length === 0) {
        await conn.rollback();
      return res.status(404).json({ 
        success: false, 
        error: 'Package not found',
        details: ['The specified package does not exist']
      });
    }
    
    let totalAmount = parseFloat(packages[0].price);

    // Validate and calculate add-on prices
    if (addon_ids && Array.isArray(addon_ids) && addon_ids.length > 0) {
      const placeholders = addon_ids.map(() => '?').join(',');
      const [addons] = await conn.execute(
        `SELECT addon_id, addon_price FROM addons WHERE addon_id IN (${placeholders})`, 
        addon_ids
      );
      
      // Check if all add-on IDs are valid
      if (addons.length !== addon_ids.length) {
        await conn.rollback();
        return res.status(400).json({ 
          success: false, 
          error: 'Invalid add-on IDs',
          details: ['One or more add-on IDs do not exist']
        });
      }
      
        addons.forEach(addon => {
            totalAmount += parseFloat(addon.addon_price);
        });
    }

    // Insert booking
    const formattedTime = moment(booking_time, ["h:mm a"]).format("HH:mm:ss");
    const [result] = await conn.execute(
      'INSERT INTO bookings (user_id, package_id, booking_label, booking_date, booking_time, backdrop, status, created_at, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?)',
      
      [user_id, package_id, booking_label.trim(), formattedDate, formattedTime, backdrop?.trim() || null, 'pending', totalAmount.toFixed(2)]
    );
    const booking_id = result.insertId;

    // Insert add-ons if provided
    if (addon_ids && Array.isArray(addon_ids) && addon_ids.length > 0) {
      const bookingAddonValues = addon_ids.map(id => [booking_id, id]);
      await conn.query('INSERT INTO booking_addons (booking_id, addon_id) VALUES ?', [bookingAddonValues]);
    }

    await conn.commit();

    console.log('Booking created successfully:', { booking_id, total_amount: totalAmount.toFixed(2) });

    res.status(201).json({
        success: true,
      message: 'Booking created successfully',
        booking_id: booking_id,
        total_amount: totalAmount.toFixed(2)
    });

  } catch (err) {
    console.error('Booking Error:', err.message);
    if (conn) await conn.rollback();
    res.status(500).json({ 
      success: false, 
      error: 'An error occurred while creating the booking',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// --- Payments (ENHANCED VALIDATION) ---
app.post('/payment', async (req, res) => {
    const { booking_id, amount, payment_method, proof_image_url } = req.body;
  
  console.log('Payment request received:', {
    booking_id, amount, payment_method, proof_image_url
  });
  
  // Comprehensive validation
  const errors = [];
  
  if (!booking_id || !validateId(booking_id)) {
    errors.push('Valid booking_id is required');
  }
  
  if (!amount || !validateAmount(amount)) {
    errors.push('Valid amount is required (must be greater than 0)');
  }
  
  if (!payment_method || !['GCash', 'Cash', 'Card'].includes(payment_method)) {
    errors.push('Valid payment method is required (GCash, Cash, or Card)');
  }
  
  if (proof_image_url && typeof proof_image_url !== 'string') {
    errors.push('Proof image URL must be a string');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
    }

    let conn;
    try {
        conn = await getConnection();
        await conn.beginTransaction();

    // Check if booking exists and is not already paid
    const [bookings] = await conn.execute(
      'SELECT status, total_amount FROM bookings WHERE booking_id = ?', 
      [booking_id]
    );
    
    if (bookings.length === 0) {
      await conn.rollback();
      return res.status(404).json({ 
        success: false, 
        error: 'Booking not found',
        details: ['The specified booking does not exist']
      });
    }
    
    if (bookings[0].status === 'paid') {
      await conn.rollback();
      return res.status(400).json({ 
        success: false, 
        error: 'Booking is already paid',
        details: ['This booking has already been paid for']
      });
    }
    
    // Validate amount matches booking total (with tolerance)
    const bookingTotal = parseFloat(bookings[0].total_amount);
    const paymentAmount = parseFloat(amount);
    const tolerance = 0.01; // Allow 1 cent difference for floating point precision
    
    if (Math.abs(paymentAmount - bookingTotal) > tolerance) {
      await conn.rollback();
      return res.status(400).json({ 
        success: false, 
        error: 'Amount mismatch',
        details: [`Payment amount (${paymentAmount}) does not match booking total (${bookingTotal})`]
      });
    }

    // Insert payment record
        const [paymentResult] = await conn.execute(
            'INSERT INTO payments (booking_id, amount, payment_method, proof_image, status, paid_at) VALUES (?, ?, ?, ?, ?, NOW())',
      [booking_id, paymentAmount, payment_method, proof_image_url || null, 'pending']
        );

    // Update booking status to paid
        await conn.execute(
            "UPDATE bookings SET status = 'paid' WHERE booking_id = ?",
            [booking_id]
        );

        await conn.commit();

    console.log('Payment processed successfully:', { payment_id: paymentResult.insertId, booking_id });

    res.status(201).json({ 
      success: true, 
      message: 'Payment processed successfully',
      payment_id: paymentResult.insertId,
      booking_id: booking_id
    });
    } catch (err) {
        if (conn) await conn.rollback();
        console.error('Payment Error:', err.message);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to process payment',
      details: [err.message]
    });
    } finally {
        if (conn) conn.release();
    }
});

// --- Profile (ENHANCED VALIDATION) ---
app.get('/profile/:userId', async (req, res) => {
    const { userId } = req.params;
  
  console.log('Profile request received:', { userId });

  // Validation
  if (!userId || !validateId(userId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid user ID',
      details: ['User ID must be a valid positive integer']
    });
  }

    let conn;
    try {
        conn = await getConnection();
    const [rows] = await conn.execute(
      'SELECT user_id, first_name, last_name, email, phone FROM users WHERE user_id = ?', 
      [userId]
    );
    
        if (rows.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'User not found',
        details: ['The specified user does not exist']
      });
    }
    
    console.log('Profile fetched successfully:', { user_id: userId });
    
    return res.json({ 
      success: true, 
      message: 'Profile fetched successfully',
      profile: rows[0] 
    });
    } catch (err) {
        console.error('Profile Fetch Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Server error fetching profile',
      details: [err.message]
    });
    } finally {
        if (conn) conn.release();
    }
});

// --- Password Reset Flow (ENHANCED VALIDATION) ---

app.post('/forgot-password', async (req, res) => {
  const { email } = req.body;
  
  console.log('Forgot password request received:', { email });

  // Validation
  if (!email || !validateEmail(email)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid email address',
      details: ['Please provide a valid email address']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    const [users] = await conn.execute('SELECT user_id, email FROM users WHERE email = ?', [email.toLowerCase()]);
    
    if (users.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Email not found',
        details: ['No account found with this email address']
      });
    }
    
    const user = users[0];
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes
    
    await conn.execute(
      'INSERT INTO password_reset_codes (user_id, code, expires_at) VALUES (?, ?, ?)',
      [user.user_id, code, expiresAt]
    );
    
    console.log('Password reset code generated:', { user_id: user.user_id, email });
    
    // SECURITY WARNING: In a real app, you must send this code to the user's email,
    // not return it in the API response.
    return res.json({ 
      success: true, 
      message: "If a user with that email exists, a reset code has been sent.",
      code: code // Remove this in production
    });
  } catch (err) {
    console.error('Forgot Password Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to process password reset request',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

app.post('/verify-reset-code', async (req, res) => {
  const { email, code } = req.body;
  
  console.log('Verify reset code request received:', { email });

  // Validation
  const errors = [];
  
  if (!email || !validateEmail(email)) {
    errors.push('Valid email address is required');
  }
  
  if (!code || !/^\d{6}$/.test(code)) {
    errors.push('Valid 6-digit code is required');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
  }

  let conn;
  try {
    conn = await getConnection();
    const [users] = await conn.execute('SELECT user_id FROM users WHERE email = ?', [email.toLowerCase()]);
    
    if (users.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Email not found',
        details: ['No account found with this email address']
      });
    }
    
    const userId = users[0].user_id;
    const [codes] = await conn.execute(
      'SELECT * FROM password_reset_codes WHERE user_id = ? AND code = ? AND used = 0 AND expires_at > NOW() ORDER BY code_id DESC LIMIT 1',
      [userId, code]
    );
    
    if (codes.length === 0) {
      return res.status(400).json({ 
        success: false, 
        error: 'Invalid or expired code',
        details: ['The reset code is invalid or has expired']
      });
    }
    
    console.log('Reset code verified successfully:', { user_id: userId });
    
    return res.json({ 
      success: true,
      message: 'Reset code verified successfully'
    });
  } catch (err) {
    console.error('Verify Code Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to verify reset code',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

app.post('/reset-password', async (req, res) => {
  const { email, code, new_password } = req.body;
  
  console.log('Reset password request received:', { email });

  // Validation
  const errors = [];
  
  if (!email || !validateEmail(email)) {
    errors.push('Valid email address is required');
  }
  
  if (!code || !/^\d{6}$/.test(code)) {
    errors.push('Valid 6-digit code is required');
  }
  
  if (!validatePassword(new_password)) {
    errors.push('New password must be at least 6 characters long');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
  }

  let conn;
  try {
    conn = await getConnection();
    await conn.beginTransaction();

    const [users] = await conn.execute('SELECT user_id FROM users WHERE email = ?', [email.toLowerCase()]);
    
    if (users.length === 0) {
      await conn.rollback();
      return res.status(404).json({ 
        success: false, 
        error: 'Email not found',
        details: ['No account found with this email address']
      });
    }
    
    const userId = users[0].user_id;

    const [codes] = await conn.execute(
      'SELECT code_id FROM password_reset_codes WHERE user_id = ? AND code = ? AND used = 0 AND expires_at > NOW() ORDER BY code_id DESC LIMIT 1',
      [userId, code]
    );
    
    if (codes.length === 0) {
      await conn.rollback();
      return res.status(400).json({ 
        success: false, 
        error: 'Invalid or expired code',
        details: ['The reset code is invalid or has expired']
      });
    }
    
    const hash = await bcrypt.hash(new_password, 10);
    await conn.execute('UPDATE users SET password_hash = ? WHERE user_id = ?', [hash, userId]);
    await conn.execute('UPDATE password_reset_codes SET used = 1 WHERE code_id = ?', [codes[0].code_id]);

    await conn.commit();
    
    console.log('Password reset successfully:', { user_id: userId });

    return res.json({ 
      success: true,
      message: 'Password reset successfully'
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error('Reset Password Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to reset password',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// --- Update Password (ENHANCED VALIDATION) ---
app.post('/update-password', async (req, res) => {
  const { email, new_password } = req.body;
  
  console.log('Update password request received:', { email });

  // Validation
  const errors = [];
  
  if (!email || !validateEmail(email)) {
    errors.push('Valid email address is required');
  }
  
  if (!validatePassword(new_password)) {
    errors.push('New password must be at least 6 characters long');
  }

  if (errors.length > 0) {
    return res.status(400).json({ 
      success: false, 
      error: 'Validation failed', 
      details: errors 
    });
  }

  let conn;
  try {
    conn = await getConnection();
    const [users] = await conn.execute('SELECT user_id FROM users WHERE email = ?', [email.toLowerCase()]);
    
    if (users.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Email not found',
        details: ['No account found with this email address']
      });
    }
    
    const userId = users[0].user_id;
    const hash = await bcrypt.hash(new_password, 10);
    await conn.execute('UPDATE users SET password_hash = ? WHERE user_id = ?', [hash, userId]);
    
    console.log('Password updated successfully:', { user_id: userId });
    
    return res.json({ 
      success: true,
      message: 'Password updated successfully'
    });
  } catch (err) {
    console.error('Update Password Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to update password',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// --- Additional CRUD Endpoints ---

// Get all bookings for a user
app.get('/bookings/:userId', async (req, res) => {
  const { userId } = req.params;
  
  console.log('Get bookings request received:', { userId });

  if (!userId || !validateId(userId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid user ID',
      details: ['User ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    const [bookings] = await conn.execute(`
      SELECT b.*, p.title as package_title, p.price as package_price
      FROM bookings b
      JOIN packages p ON b.package_id = p.package_id
      WHERE b.user_id = ?
      ORDER BY b.created_at DESC
    `, [userId]);
    
    console.log(`Fetched ${bookings.length} bookings for user ${userId}`);
    
    return res.json({ 
      success: true, 
      message: `${bookings.length} bookings found`,
      bookings 
    });
  } catch (err) {
    console.error('Get Bookings Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to fetch bookings',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// Get booking details with add-ons
app.get('/booking/:bookingId', async (req, res) => {
  const { bookingId } = req.params;
  
  console.log('Get booking details request received:', { bookingId });

  if (!bookingId || !validateId(bookingId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid booking ID',
      details: ['Booking ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Get booking details
    const [bookings] = await conn.execute(`
      SELECT b.*, p.title as package_title, p.package_type, u.first_name, u.last_name, u.email
      FROM bookings b
      JOIN packages p ON b.package_id = p.package_id
      JOIN users u ON b.user_id = u.user_id
      WHERE b.booking_id = ?
    `, [bookingId]);
    
    if (bookings.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Booking not found',
        details: ['The specified booking does not exist']
      });
    }
    
    // Get add-ons for this booking
    const [addons] = await conn.execute(`
      SELECT a.addon_name, a.addon_price
      FROM booking_addons ba
      JOIN addons a ON ba.addon_id = a.addon_id
      WHERE ba.booking_id = ?
    `, [bookingId]);
    
    const booking = bookings[0];
    booking.addons = addons;
    
    console.log('Booking details fetched successfully:', { booking_id: bookingId });
    
    return res.json({ 
      success: true, 
      message: 'Booking details fetched successfully',
      booking 
    });
  } catch (err) {
    console.error('Get Booking Details Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to fetch booking details',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// Cancel booking
app.put('/booking/:bookingId/cancel', async (req, res) => {
  const { bookingId } = req.params;
  
  console.log('Cancel booking request received:', { bookingId });

  if (!bookingId || !validateId(bookingId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid booking ID',
      details: ['Booking ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Check if booking exists and can be cancelled
    const [bookings] = await conn.execute(
      'SELECT status FROM bookings WHERE booking_id = ?', 
      [bookingId]
    );
    
    if (bookings.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Booking not found',
        details: ['The specified booking does not exist']
      });
    }
    
    if (bookings[0].status === 'cancelled') {
      return res.status(400).json({ 
        success: false, 
        error: 'Booking already cancelled',
        details: ['This booking has already been cancelled']
      });
    }
    
    if (bookings[0].status === 'paid') {
      return res.status(400).json({ 
        success: false, 
        error: 'Cannot cancel paid booking',
        details: ['Paid bookings cannot be cancelled']
      });
    }
    
    // Cancel the booking
    await conn.execute(
      "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ?",
      [bookingId]
    );
    
    console.log('Booking cancelled successfully:', { booking_id: bookingId });
    
    return res.json({ 
      success: true,
      message: 'Booking cancelled successfully'
    });
  } catch (err) {
    console.error('Cancel Booking Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to cancel booking',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// --- DELETE Endpoints ---

// Delete user (soft delete - mark as inactive)
app.delete('/user/:userId', async (req, res) => {
  const { userId } = req.params;
  
  console.log('Delete user request received:', { userId });

  if (!userId || !validateId(userId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid user ID',
      details: ['User ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Check if user exists
    const [users] = await conn.execute('SELECT user_id FROM users WHERE user_id = ?', [userId]);
    
    if (users.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'User not found',
        details: ['The specified user does not exist']
      });
    }
    
    // Check if user has active bookings
    const [activeBookings] = await conn.execute(
      "SELECT COUNT(*) as count FROM bookings WHERE user_id = ? AND status IN ('pending', 'confirmed')",
      [userId]
    );
    
    if (activeBookings[0].count > 0) {
      return res.status(400).json({ 
        success: false, 
        error: 'Cannot delete user with active bookings',
        details: ['User has active bookings that must be cancelled first']
      });
    }
    
    // Soft delete - mark user as inactive (you might want to add an 'active' column to users table)
    // For now, we'll delete the user directly
    await conn.execute('DELETE FROM users WHERE user_id = ?', [userId]);
    
    console.log('User deleted successfully:', { user_id: userId });
    
    return res.json({ 
      success: true,
      message: 'User deleted successfully'
    });
  } catch (err) {
    console.error('Delete User Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to delete user',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// Delete booking (only if not paid)
app.delete('/booking/:bookingId', async (req, res) => {
  const { bookingId } = req.params;
  
  console.log('Delete booking request received:', { bookingId });

  if (!bookingId || !validateId(bookingId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid booking ID',
      details: ['Booking ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Check if booking exists
    const [bookings] = await conn.execute(
      'SELECT status FROM bookings WHERE booking_id = ?', 
      [bookingId]
    );
    
    if (bookings.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Booking not found',
        details: ['The specified booking does not exist']
      });
    }
    
    if (bookings[0].status === 'paid') {
      return res.status(400).json({ 
        success: false, 
        error: 'Cannot delete paid booking',
        details: ['Paid bookings cannot be deleted']
      });
    }
    
    // Delete booking add-ons first (due to foreign key constraint)
    await conn.execute('DELETE FROM booking_addons WHERE booking_id = ?', [bookingId]);
    
    // Delete the booking
    await conn.execute('DELETE FROM bookings WHERE booking_id = ?', [bookingId]);
    
    console.log('Booking deleted successfully:', { booking_id: bookingId });
    
    return res.json({ 
      success: true,
      message: 'Booking deleted successfully'
    });
  } catch (err) {
    console.error('Delete Booking Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to delete booking',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// Delete payment
app.delete('/payment/:paymentId', async (req, res) => {
  const { paymentId } = req.params;
  
  console.log('Delete payment request received:', { paymentId });

  if (!paymentId || !validateId(paymentId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid payment ID',
      details: ['Payment ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Check if payment exists
    const [payments] = await conn.execute(
      'SELECT payment_id, booking_id FROM payments WHERE payment_id = ?', 
      [paymentId]
    );
    
    if (payments.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Payment not found',
        details: ['The specified payment does not exist']
      });
    }
    
    const bookingId = payments[0].booking_id;
    
    // Delete the payment
    await conn.execute('DELETE FROM payments WHERE payment_id = ?', [paymentId]);
    
    // Update booking status back to pending
    await conn.execute(
      "UPDATE bookings SET status = 'pending' WHERE booking_id = ?",
      [bookingId]
    );
    
    console.log('Payment deleted successfully:', { payment_id: paymentId, booking_id: bookingId });
    
    return res.json({ 
      success: true,
      message: 'Payment deleted successfully'
    });
  } catch (err) {
    console.error('Delete Payment Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to delete payment',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// Delete add-on from booking
app.delete('/booking/:bookingId/addon/:addonId', async (req, res) => {
  const { bookingId, addonId } = req.params;
  
  console.log('Delete add-on from booking request received:', { bookingId, addonId });

  if (!bookingId || !validateId(bookingId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid booking ID',
      details: ['Booking ID must be a valid positive integer']
    });
  }

  if (!addonId || !validateId(addonId)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid add-on ID',
      details: ['Add-on ID must be a valid positive integer']
    });
  }

  let conn;
  try {
    conn = await getConnection();
    
    // Check if booking exists
    const [bookings] = await conn.execute(
      'SELECT status FROM bookings WHERE booking_id = ?', 
      [bookingId]
    );
    
    if (bookings.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Booking not found',
        details: ['The specified booking does not exist']
      });
    }
    
    if (bookings[0].status === 'paid') {
      return res.status(400).json({ 
        success: false, 
        error: 'Cannot modify paid booking',
        details: ['Paid bookings cannot be modified']
      });
    }
    
    // Check if add-on exists in booking
    const [bookingAddons] = await conn.execute(
      'SELECT * FROM booking_addons WHERE booking_id = ? AND addon_id = ?', 
      [bookingId, addonId]
    );
    
    if (bookingAddons.length === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'Add-on not found in booking',
        details: ['The specified add-on is not associated with this booking']
      });
    }
    
    // Delete the add-on from booking
    await conn.execute(
      'DELETE FROM booking_addons WHERE booking_id = ? AND addon_id = ?', 
      [bookingId, addonId]
    );
    
    // Recalculate booking total
    const [addons] = await conn.execute(`
      SELECT a.addon_price 
      FROM booking_addons ba 
      JOIN addons a ON ba.addon_id = a.addon_id 
      WHERE ba.booking_id = ?
    `, [bookingId]);
    
    const [package] = await conn.execute(
      'SELECT price FROM packages WHERE package_id = (SELECT package_id FROM bookings WHERE booking_id = ?)', 
      [bookingId]
    );
    
    let totalAmount = parseFloat(package[0].price);
    addons.forEach(addon => {
      totalAmount += parseFloat(addon.addon_price);
    });
    
    // Update booking total
    await conn.execute(
      'UPDATE bookings SET total_amount = ? WHERE booking_id = ?',
      [totalAmount.toFixed(2), bookingId]
    );
    
    console.log('Add-on removed from booking successfully:', { booking_id: bookingId, addon_id: addonId });
    
    return res.json({ 
      success: true,
      message: 'Add-on removed from booking successfully',
      new_total: totalAmount.toFixed(2)
    });
  } catch (err) {
    console.error('Delete Add-on Error:', err.message);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to remove add-on from booking',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

// --- Get all users ---
app.get('/users', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const [users] = await conn.execute('SELECT user_id, first_name, last_name, email, phone FROM users ORDER BY user_id');
    console.log(`Fetched ${users.length} users successfully`);
    return res.json({
      success: true,
      users,
      message: `${users.length} users found`
    });
  } catch (err) {
    console.error('Get Users Error:', err.message);
    return res.status(500).json({
      success: false,
      error: 'Failed to fetch users',
      details: [err.message]
    });
  } finally {
    if (conn) conn.release();
  }
});

app.get('/', (req, res) => {
  res.send('Lenshine API is running.');
});

// Test database connection
app.get('/test-db', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const [rows] = await conn.execute('SELECT 1 as test');
    res.json({ success: true, message: 'Database connection successful', data: rows[0] });
  } catch (err) {
    console.error('Database test error:', err);
    res.status(500).json({ success: false, error: 'Database connection failed: ' + err.message });
  } finally {
    if (conn) conn.release();
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server is running on http://0.0.0.0:${PORT}`);
  console.log(`📱 Accessible from your network at http://192.168.197.12:${PORT}`);
  console.log(`🤖 For Android emulator, use: http://10.0.2.2:${PORT}`);
  console.log(`🔗 Test connection: http://192.168.197.12:${PORT}/test-db`);
  console.log(`\n📋 PHYSICAL DEVICE TESTING SETUP:`);
  console.log(`1. Ensure your computer and phone are on the same WiFi network`);
  console.log(`2. Verify IP address: 192.168.197.12`);
  console.log(`3. Check firewall allows port 3000`);
  console.log(`4. Test in browser: http://192.168.197.12:${PORT}`);
});