# Tambahkan di file utils.py atau di app.py kamu

def print_sql_query(query):
    """Print raw SQL query dari SQLAlchemy query object"""
    from sqlalchemy.dialects import mysql
    
    # Compile query jadi SQL string
    compiled = query.statement.compile(
        dialect=mysql.dialect(),
        compile_kwargs={"literal_binds": True}
    )
    print("\n=== SQL QUERY ===")
    print(compiled)
    print("=================\n")
    return query


def debug_query(query):
    """Debug query dan return hasilnya sekaligus"""
    print_sql_query(query)
    result = query.all()
    print(f"Jumlah hasil: {len(result)}")
    return result


def explain_query(query):
    """Tampilkan EXPLAIN dari query untuk performance debugging"""
    sql = str(query.statement.compile(compile_kwargs={"literal_binds": True}))
    explain_result = db.session.execute(f"EXPLAIN {sql}")
    
    print("\n=== EXPLAIN RESULT ===")
    for row in explain_result:
        print(row)
    print("======================\n")


# Function untuk enable SQL logging di console
def enable_sql_logging():
    """Enable logging semua SQL query ke console"""
    import logging
    logging.basicConfig()
    logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)
