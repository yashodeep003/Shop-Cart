package com.servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Paths;

import com.beans.ProductBean;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 15   // 15 MB
)
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== ADD PRODUCT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            // Get form parameters from multipart form
            String productName = getParameterFromPart(request, "productName");
            String productPrice = getParameterFromPart(request, "productPrice");
            String productQuantity = getParameterFromPart(request, "productQuantity");
            String productCategory = getParameterFromPart(request, "productCategory");
            String productDescription = getParameterFromPart(request, "productDescription");
            
            // DEBUG PRINTS
            System.out.println("===== RECEIVED VALUES =====");
            System.out.println("productName: '" + productName + "'");
            System.out.println("productPrice: '" + productPrice + "'");
            System.out.println("productQuantity: '" + productQuantity + "'");
            System.out.println("productCategory: '" + productCategory + "'");
            System.out.println("productDescription: '" + productDescription + "'");
            System.out.println("===========================");
            
            // Validate required fields
            if(productName == null || productName.trim().isEmpty()) {
                System.out.println("ERROR: Product name is required");
                response.sendRedirect(request.getContextPath() + "/admin/addProduct.jsp?error=namerequired");
                return;
            }
            
            if(productPrice == null || productPrice.trim().isEmpty()) {
                System.out.println("ERROR: Product price is required");
                response.sendRedirect(request.getContextPath() + "/admin/addProduct.jsp?error=pricerequired");
                return;
            }
            
            if(productQuantity == null || productQuantity.trim().isEmpty()) {
                System.out.println("ERROR: Product quantity is required");
                response.sendRedirect(request.getContextPath() + "/admin/addProduct.jsp?error=quantityrequired");
                return;
            }
            
            // Handle file upload
            Part filePart = request.getPart("productImage");
            String fileName = null;
            
            if(filePart != null && filePart.getSize() > 0) {
                // Get the original filename
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                System.out.println("Uploaded file name: " + fileName);
                
                // Define upload path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                    System.out.println("Created upload directory: " + uploadPath);
                }
                
                // Save the file
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                System.out.println("File saved to: " + filePath);
            } else {
                System.out.println("No file uploaded, using placeholder image");
                fileName = "placeholder.jpg";
            }
            
            // Create ProductBean
            ProductBean product = new ProductBean();
            product.setP_Name(productName);
            product.setP_Price(productPrice);
            product.setP_Quantity(productQuantity);
            product.setP_Image(fileName);
            
            System.out.println("Product bean created with values:");
            System.out.println("  Name: " + product.getP_Name());
            System.out.println("  Price: " + product.getP_Price());
            System.out.println("  Quantity: " + product.getP_Quantity());
            System.out.println("  Image: " + product.getP_Image());
            
            // Get DAO and save product
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj != null) {
                System.out.println("Calling DAO.addProduct...");
                boolean added = DAOobj.addProduct(product);
                
                if(added) {
                    System.out.println("Product added successfully to database");
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?success=added");
                } else {
                    System.out.println("Failed to add product to database");
                    response.sendRedirect(request.getContextPath() + "/admin/addProduct.jsp?error=failed");
                }
            } else {
                System.out.println("DAO object is null");
                response.sendRedirect(request.getContextPath() + "/admin/addProduct.jsp?error=system");
            }
            
        } catch(Exception e) {
            System.out.println("Exception in AddProductServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/addProduct.jsp?error=exception");
        }
    }
    
    /**
     * Helper method to get parameter value from multipart form
     */
    private String getParameterFromPart(HttpServletRequest request, String paramName) 
            throws IOException, ServletException {
        Part part = request.getPart(paramName);
        if(part != null && part.getSize() > 0) {
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(part.getInputStream(), "UTF-8"))) {
                return reader.readLine();
            }
        }
        return null;
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}